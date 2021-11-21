
import Foundation
enum Money: Int, CaseIterable {
    case low
    case middle
    case high
    var name: String {
        switch self {
        case .low:
            return "500円~1000円"
        case .middle:
            return "1000円~2000円"
        case .high:
            return "2000円~"
        }
    }
}
