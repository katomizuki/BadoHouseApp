
enum Money: Int, CaseIterable {
    case low, middle, high
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
