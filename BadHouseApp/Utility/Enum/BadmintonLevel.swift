
enum BadmintonLevel: Int, CaseIterable {
    case one,two,three,four,five,six,seven,eight,nine,ten
    var description:String {
        switch self {
        case .one:
            return "レベル1"
        case .two:
            return "レベル2"
        case .three:
            return "レベル3"
        case .four:
            return "レベル4"
        case .five:
            return "レベル5"
        case .six:
            return "レベル6"
        case .seven:
            return "レベル7"
        case .eight:
            return "レベル8"
        case .nine:
            return "レベル9"
        case .ten:
            return "レベル10"
        }
    }
    static let level = ["レベル1", "レベル2", "レベル3", "レベル4", "レベル5", "レベル6", "レベル7", "レベル8", "レベル9", "レベル10"]
}
