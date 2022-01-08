//
//  NotificationEnum.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

enum NotificationEnum:Int,CaseIterable {
    case applyed,prejoined,permissionJoin,permissionFriend
    var description:String {
        switch self {
        case .applyed: return "さんから友だち申請がきました"
        case .prejoined: return "さんから参加申請がきました"
        case .permissionJoin:return "の練習参加が決定しました"
        case .permissionFriend: return "さんと友だちになりました"
        }
    }
}
