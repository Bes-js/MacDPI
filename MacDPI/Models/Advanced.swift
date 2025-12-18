import SwiftData
import Foundation


@Model
final class AdvancedConfig {
    var dnsIPv4Only: Bool
    var dnsOverHttps: Bool
    var systemProxy: Bool
    var timeout: String
    var clientHelloChunkSize: String
    
    init(
         dnsIPv4Only: Bool = false,
         dnsOverHttps: Bool = true,
         systemProxy: Bool = true,
         timeout: String = "5",
         clientHelloChunkSize: String = "1"
    ) {
        self.dnsIPv4Only = dnsIPv4Only
        self.dnsOverHttps = dnsOverHttps
        self.systemProxy = systemProxy
        self.timeout = timeout
        self.clientHelloChunkSize = clientHelloChunkSize
    }
}
