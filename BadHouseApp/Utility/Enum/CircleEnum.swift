enum BadmintonCircle: Int, CaseIterable {
    case student, society, other
    var name: String {
        switch self {
        case .student:
            return "学生サークル"
        case .society:
            return "社会人サークル"
        case .other:
            return "その他練習"
        }
    }
}
