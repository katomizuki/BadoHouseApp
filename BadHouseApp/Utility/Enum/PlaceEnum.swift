
import Foundation
enum Place: Int, CaseIterable {
    case kanagawa, tokyo, chiba, saitama
//    case tokyo
//    case chiba
//    case saitama
    var name: String {
        switch self {
        case .kanagawa:
            return "神奈川県"
        case .chiba:
            return "千葉県"
        case .saitama:
            return "埼玉県"
        case .tokyo:
            return "東京都"
        }
    }
    static let placeArray = ["東京都", "神奈川県", "千葉県", "埼玉県"]
}
