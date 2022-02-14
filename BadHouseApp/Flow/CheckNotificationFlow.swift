//
//  CheckNotificationFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

protocol CheckNotificationFlow: AnyObject {
    func toUserDetail(_ myData: User, user: User)
    func toPracticeDetail(_ myData: User, practice: Practice)
    func toPreJoin(_ user: User)
    func toPreJoined(_ user: User)
    func toApplyedFriend(_ user: User)
}
