enum SettingsSelection: Int, CaseIterable {
    case block, practice, app, rule, apply
    var description: String {
        switch self {
        case .block:
            return "ブロックリスト"
        case .practice:
            return "自分の募集中の練習"
        case .app:
            return "アプリ説明"
        case .rule:
            return "アプリ規約"
        case .apply:
            return "不具合の報告"
        }
    }
}
