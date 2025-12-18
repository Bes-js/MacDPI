import Foundation
import AppKit

class DependencyManager {
    
    static let shared = DependencyManager()
    private let brewPaths = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew"]
    
    private var activeBrewPath: String? {
        return brewPaths.first { FileManager.default.fileExists(atPath: $0) }
    }
    
    func areDependenciesReady() -> Bool {
        return isHomebrewInstalled() && isSpoofDPIInstalled()
    }
    
    func isHomebrewInstalled() -> Bool {
        return activeBrewPath != nil
    }
    
    func installHomebrew(completion: @escaping (Bool, String) -> Void) {
        
        var installPath = "/usr/local/Homebrew"
        
        var sysinfo = utsname()
        uname(&sysinfo)
        let machine = withUnsafeBytes(of: &sysinfo.machine) { buf in
            String(cString: buf.baseAddress!.assumingMemoryBound(to: CChar.self))
        }
        
        if machine == "arm64" {
            installPath = "/opt/homebrew"
        }
        
        let currentUser = NSUserName()
        let prepareCommand = "mkdir -p \(installPath) && chown -R \(currentUser):admin \(installPath)"
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let adminScript = """
            do shell script "/bin/sh -c \\"\(prepareCommand)\\"" with administrator privileges
            """
            
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: adminScript) {
                scriptObject.executeAndReturnError(&error)
                
                if let error = error {
                    DispatchQueue.main.async {
                        let msg = error["NSAppleScriptErrorMessage"] as? String ?? "Permission Error"
                        completion(false, "Failed to obtain folder permission: \(msg)")
                    }
                    return
                }
                
                self.downloadAndExtractHomebrew(to: installPath) { success, msg in
                    if success {
                        DispatchQueue.main.async {
                            completion(true, "Homebrew Installed Successfully!")
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(false, msg)
                        }
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false, "Failed to start AppleScript.")
                }
            }
        }
    }
    
    private func downloadAndExtractHomebrew(to path: String, completion: @escaping (Bool, String) -> Void) {
        let command = "curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C \(path)"
        
        let output = runShellCommand(command)
        
        let brewBinary = "\(path)/bin/brew"
        if FileManager.default.fileExists(atPath: brewBinary) {
            _ = runShellCommand("\(brewBinary) update")
            completion(true, "Installation completed.")
        } else {
            completion(false, "Files could not be downloaded. Please check your internet connection.\nOutput: \(output)")
        }
    }
    
   
    func isSpoofDPIInstalled() -> Bool {
        guard let brewPath = activeBrewPath else { return false }
        let output = runShellCommand("\(brewPath) list spoofdpi")
        return (output.contains("No such") == false)
    }
    
    func installSpoofDPI(completion: @escaping (Bool, String) -> Void) {
        guard let brewPath = activeBrewPath else {
            completion(false, "Homebrew not found.")
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            let command = "\(brewPath) install spoofdpi"
            let output = self.runShellCommand(command)
            
            DispatchQueue.main.async {
                if output.lowercased().contains("error") && !output.contains("already installed") {
                    completion(false, "SpoofDPI Error: \(output)")
                } else {
                    completion(true, "SpoofDPI Ready.")
                }
            }
        }
    }
    
   
    private func runShellCommand(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        
        var env = ProcessInfo.processInfo.environment
        env["PATH"] = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        task.environment = env
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return "Terminal Error: \(error.localizedDescription)"
        }
    }
}
