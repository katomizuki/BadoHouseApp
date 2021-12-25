
enum UserInfoSelection: Int, CaseIterable {
    case level, gender, badmintonTime, place, age
    var description:String {
        switch self {
        case .place: return "居住地"
        case .gender: return "性別"
        case .level: return "レベル"
        case .badmintonTime: return "バドミントン歴"
        case .age: return "年代"
        }
    }
}
