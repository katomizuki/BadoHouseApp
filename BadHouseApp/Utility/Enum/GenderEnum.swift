
enum Gender: Int, CaseIterable {
    case man, woman, other
    var name: String {
        switch self {
        case .man:
            return "男性"
        case .woman:
            return "女性"
        case .other:
            return "その他"
        }
    }
    static let genderArray = ["男性", "女性", "その他"]
}
