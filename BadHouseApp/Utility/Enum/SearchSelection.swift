//
//  SearchSelection.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//



enum SearchSelection:Int ,CaseIterable {
    case place,level,time,name
    var description:String {
        switch self {
        case .place:
            return "〇〇件"
        case .level:
            return "レベル"
        case .time:
            return "日程"
        case .name:
            return "サークル名"
        }
    }
}
