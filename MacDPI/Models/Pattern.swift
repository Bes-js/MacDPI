import SwiftData
import Foundation

@Model
final class PatternItem {
    var id: Int
    var domain: String
    
    init(
        id: Int, domain: String
    ) {
        self.id = id
        self.domain = domain
    }
}

