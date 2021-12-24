//
//  SettingsSelection.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

enum SettingsSelection:Int,CaseIterable {
    case password,email,app,rule,apply
    var description:String {
        switch self {
        case .password:
            return "パスワード変更"
        case .email:
            return "メール変更"
        case .app:
            return "アプリ説明"
        case .rule:
            return "アプリ規約"
        case .apply:
            return "不具合の報告"
        }
    }
}
