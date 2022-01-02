//
//  SearchSelection.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/25.
//



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
