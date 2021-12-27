//
//  CircleFeatures.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/27.
//

enum CircleFeatures: Int, CaseIterable {
    case single,double,mix,practiceMain,gameMain,notGender,notAge,weekDay,weekEnd
    var description:String {
        switch self {
        case .single: return "シングルス"
        case .double: return "ダブルス"
        case .mix: return "ミックス"
        case .practiceMain: return "練習メイン"
        case .gameMain: return "試合メイン"
        case .notGender: return "性別不問"
        case .notAge: return "年齢不問"
        case .weekDay: return "平日開催"
        case .weekEnd: return "土日開催"
        }
    }
}
