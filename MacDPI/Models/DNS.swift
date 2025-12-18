import SwiftData
import Foundation


@Model
final class DNSConfig {
    var service: String
    var address: String
    var port: Int
    
    init(
         service: String = "google",
         address: String = "8.8.8.8",
         port: Int = 53
    ) {
        self.service = service
        self.address = address
        self.port = port
    }
}
