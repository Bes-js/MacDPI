import Foundation
import Combine
import SwiftData
import UserNotifications

struct UnsafeSendableWrapper<T>: @unchecked Sendable {
    let value: T
}

class DPIEngine: ObservableObject {
    
    private var currentProcess: Process?
    private var outputPipe: Pipe?
    private var isRetrying = false
    
    private var binaryPath: String? {
        
        if FileManager.default.fileExists(atPath: "/opt/homebrew/bin/spoofdpi") {
            return "/opt/homebrew/bin/spoofdpi"
        }
        
        if FileManager.default.fileExists(atPath: "/usr/local/bin/spoofdpi") {
            return "/usr/local/bin/spoofdpi"
        }

        return nil
    }

    
    func checkSpoofDPIInstalled() -> Bool {
        return binaryPath != nil
    }


    @MainActor
    func startDPI(with services: Services) async -> Bool {
        
        let servicesWrapper = UnsafeSendableWrapper(value: services)
        
        if currentProcess != nil {
            _ = await stopDPI(with: services)
        }
        
        guard let executablePath = binaryPath else {
            return false
        }
        
        let patternRegex = services.patterns
            .map { NSRegularExpression.escapedPattern(for: $0.domain) }
            .joined(separator: "|")
        
        let timeoutVal = (Double(services.advanced?.timeout ?? "5") ?? 5.0) * 1000
        
        var args: [String] = []
        
        let addr = (services.proxy?.useDefaultAddress == true) ? "127.0.0.1" : (services.proxy?.address ?? "127.0.0.1")
        let port = (services.proxy?.useDefaultPort == true) ? "8080" : String(services.proxy?.port ?? 8080)
        
        args.append(contentsOf: ["--listen-addr", addr])
        args.append(contentsOf: ["--listen-port", port])
        
        if let dns = services.dns {
            args.append(contentsOf: ["--dns-addr", dns.address])
            args.append(contentsOf: ["--dns-port", String(dns.port)])
        }
        
        if let adv = services.advanced {
            args.append(contentsOf: ["--window-size", adv.clientHelloChunkSize])
            args.append(contentsOf: ["--timeout", String(Int(timeoutVal))])
            
            if adv.dnsIPv4Only { args.append("--dns-ipv4-only") }
            if adv.dnsOverHttps { args.append("--enable-doh") }
            if adv.systemProxy { args.append("--system-proxy") }
        }
        
        if !patternRegex.isEmpty {
            let fullPattern = ".*(?:\(patternRegex)).*"
            args.append(contentsOf: ["--policy", fullPattern])
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: executablePath)
        process.arguments = args
        
        var env = ProcessInfo.processInfo.environment
        let existingPath = env["PATH"] ?? ""
        env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:\(existingPath)"
        process.environment = env
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe
        self.outputPipe = pipe
        
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
                    let data = handle.availableData
                    guard let self = self, let output = String(data: data, encoding: .utf8), !output.isEmpty else { return }
                    
            if output.contains("address already in use") {

                Task {
            
                    let content = UNMutableNotificationContent()
                    content.title = "Port Conflict Detected"
                    content.body = "The selected address (\(addr)) and port (\(port)) are already in use. The process will be restarted."
                    content.sound = .default
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
          
                    try? await UNUserNotificationCenter.current().add(request)

                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    await self.stopDPI(with: servicesWrapper.value)
                    return false
                }
            }
            
            
    }
        
        
        do {
            try process.run()
            self.currentProcess = process
            return true
        } catch {
            return false
        }
    }
    
    
    
    
    private func killProcessOnPort(_ port: Int) {
            
            let lsofProcess = Process()
            lsofProcess.executableURL = URL(fileURLWithPath: "/usr/sbin/lsof")
            lsofProcess.arguments = ["-t", "-i:\(port)"]
            
            let pipe = Pipe()
            lsofProcess.standardOutput = pipe
            
            do {
                try lsofProcess.run()
                lsofProcess.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                
                guard let output = String(data: data, encoding: .utf8) else { return }
                
                let pids = output.components(separatedBy: .newlines)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                
                if pids.isEmpty {
                    return
                }
                
                for pid in pids {
                    
                    let killProcess = Process()
                    killProcess.executableURL = URL(fileURLWithPath: "/bin/kill")
                    killProcess.arguments = ["-9", pid]
                    
                    try killProcess.run()
                    killProcess.waitUntilExit()
                    
                }
                
            } catch { }
        }

    @MainActor
    func stopDPI(with services: Services) async -> Bool {
        guard let process = currentProcess else {
            return false
        }
        
        /* let port = (services.proxy?.useDefaultPort == true) ? "8080" : String(services.proxy?.port ?? 8080) */
        /* let portInt = Int(port) ?? 8080 */
        /* self.killProcessOnPort(portInt) */
        
        AppDelegate.shared.status = .disconnected
        AppDelegate.shared.isToggleOn = false
        AppDelegate.shared.toggleConnection(targetState: false)
        
        if process.isRunning {
            process.terminate()
            process.waitUntilExit()
        }
        
        self.currentProcess = nil
        self.outputPipe?.fileHandleForReading.readabilityHandler = nil
        self.outputPipe = nil
    
        return true
    }
    
    
    
    @discardableResult
    func restartDPI(with services: Services) async -> Bool {
        _ = await stopDPI(with: services)
        try? await Task.sleep(nanoseconds: 500_000_000)
        return await startDPI(with: services)
    }
}
