import SwiftData
import Foundation

@Model
final class ProxyConfig {
    var address: String
    var port: Int
    var useDefaultAddress: Bool
    var useDefaultPort: Bool
    
    init(
         address: String = "127.0.0.1",
         port: Int = 8080,
         useDefaultAddress: Bool = true,
         useDefaultPort: Bool = true
    ) {
        self.address = address
        self.port = port
        self.useDefaultAddress = useDefaultAddress
        self.useDefaultPort = useDefaultPort
    }
}
