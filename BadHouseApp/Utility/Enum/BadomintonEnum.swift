
enum Badominton: Int, CaseIterable {
    case single, double, mix
    var name: String {
        switch self {
        case .single:
            return "シングルス"
        case .double:
            return "ダブルス"
        case .mix:
            return "ミックス"
        }
    }
}
