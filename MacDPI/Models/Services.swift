import SwiftData
import Foundation

@Model
final class Services {
    
    @Relationship(deleteRule: .cascade) var proxy: ProxyConfig?
    @Relationship(deleteRule: .cascade) var dns: DNSConfig?
    @Relationship(deleteRule: .cascade) var advanced: AdvancedConfig?
    @Relationship(deleteRule: .cascade) var patterns: [PatternItem] = []
    
    init() {
       
        self.proxy = ProxyConfig()
        self.dns = DNSConfig()
        self.advanced = AdvancedConfig()
        self.patterns = []
    }
}
