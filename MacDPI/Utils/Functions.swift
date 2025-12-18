import Foundation
import SwiftUI

struct SystemUtils {

        static func getMacModelIdentifier() -> String {
            let id = getRawModelIdentifier()
            let cpu = getCPUName()
            let type = getModelNameFromID(id: id)
            
            return "\(type) (\(cpu))"
        }
    
    
        private static func getRawModelIdentifier() -> String {
            var size = 0
            sysctlbyname("hw.model", nil, &size, nil, 0)
            var model = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.model", &model, &size, nil, 0)
            return String(cString: model)
        }
        
    
    
    
        private static func getCPUName() -> String {
            var size = 0
            sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0)
            var cpu = [CChar](repeating: 0, count: size)
            sysctlbyname("machdep.cpu.brand_string", &cpu, &size, nil, 0)
            
            let cpuString = String(cString: cpu)
            
            return cpuString.replacingOccurrences(of: "Apple ", with: "")
                            .replacingOccurrences(of: "(TM)", with: "")
                            .replacingOccurrences(of: " Core", with: "")
                            .trimmingCharacters(in: .whitespaces)
        }
        
    
    
    
        private static func getModelNameFromID(id: String) -> String {
            if id.hasPrefix("MacBookAir") { return "MacBook Air" }
            if id.hasPrefix("MacBookPro") { return "MacBook Pro" }
            if id.hasPrefix("iMac") { return "iMac" }
            if id.hasPrefix("Macmini") { return "Mac mini" }
            if id.hasPrefix("MacPro") { return "Mac Pro" }
            
            switch id {
            case "Mac14,2", "Mac14,15", "Mac15,12", "Mac15,13": return "MacBook Air"
            case "Mac14,7", "Mac14,5", "Mac14,9", "Mac14,10", "Mac15,3", "Mac15,6", "Mac15,7", "Mac15,8", "Mac15,9", "Mac15,10", "Mac15,11": return "MacBook Pro"
            case "Mac14,3", "Mac14,12": return "Mac mini"
            case "Mac13,1", "Mac13,2", "Mac14,13", "Mac14,14": return "Mac Studio"
            case "Mac15,4", "Mac15,5": return "iMac"
                
            default:
                return "Mac"
            }
        }
    
    
    
    
    
    static func checkConnectionType(completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let task = Process()
            task.launchPath = "/usr/sbin/system_profiler"
            task.arguments = ["SPAirPortDataType"]
            
            let pipe = Pipe()
            task.standardOutput = pipe
            
            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                
                if let output = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if output.contains("Wi-Fi") || output.contains("AirPort") {
                            completion("Wi-Fi")
                        } else if output.contains("Ethernet") {
                            completion("Ethernet")
                        } else {
                            completion("Ethernet/Other")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion("Error")
                }
            }
        }
    }
    
    
    
    
    static func fetchIPInfo(completion: @escaping (IPAPIResponse?) -> Void) {
        guard let url = URL(string: "http://ip-api.com/json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                do {
                    let result = try JSONDecoder().decode(IPAPIResponse.self, from: data)
                    DispatchQueue.main.async {
                        print(result)
                        completion(result)
                    }
                } catch {
                    print("JSON Parse Hatası: \(error)")
                    DispatchQueue.main.async { completion(nil) }
                }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    
    
    
    static func getMacAddress() -> String {
            let interfaceName = "en0"
            var address = "Not Found"
            
            var ifaddr: UnsafeMutablePointer<ifaddrs>?
            guard getifaddrs(&ifaddr) == 0 else { return "Error" }
            guard let firstAddr = ifaddr else { return "Error" }
            
            for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
                let interface = ifptr.pointee
                
                let name = String(cString: interface.ifa_name)
                if name == interfaceName {
                    let addr = interface.ifa_addr.pointee
                    
                    
                    if addr.sa_family == UInt8(AF_LINK) {
                        let ptr = interface.ifa_addr
                        ptr?.withMemoryRebound(to: sockaddr_dl.self, capacity: 1) { dl in
                            let socketStruct = dl.pointee
                            
                            let ptr = dl
                            let addrPtr = UnsafeRawPointer(ptr)
                                .advanced(by: MemoryLayout<sockaddr_dl>.offset(of: \.sdl_data)!)
                                .advanced(by: Int(socketStruct.sdl_nlen))
                            
                            let data = UnsafeBufferPointer(start: addrPtr.assumingMemoryBound(to: UInt8.self), count: Int(socketStruct.sdl_alen))
                            let macParts = data.map { String(format: "%02X", $0) }
                            address = macParts.joined(separator: ":")
                        }
                    }
                }
            }
            
            freeifaddrs(ifaddr)
            return address
        }
        
    
    
    
        static func getLocalIPAddress() -> String {
            var address: String = "Not Found"
            var ifaddr: UnsafeMutablePointer<ifaddrs>?
            
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while ptr != nil {
                    defer { ptr = ptr?.pointee.ifa_next }
                    
                    let interface = ptr?.pointee
                    let addrFamily = interface?.ifa_addr.pointee.sa_family
                    
                    
                    if addrFamily == UInt8(AF_INET) {
                        
                        let name = String(cString: (interface?.ifa_name)!)
                        if name == "en0" {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                                        &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
                freeifaddrs(ifaddr)
            }
            return address
        }
    
    
    
}
