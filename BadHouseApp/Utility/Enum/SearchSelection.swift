
enum SearchSelection:Int ,CaseIterable {
    case place,level
    var description:String {
        switch self {
        case .place:
            return "場所"
        case .level:
            return "レベル"
    }
}
}
