//
//  CheckNotificationFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol CheckNotificationFlow: AnyObject {
    func toUserDetail(_ myData: Domain.UserModel,
                      user: Domain.UserModel)
    func toPracticeDetail(_ myData: Domain.UserModel,
                          practice: Domain.Practice)
    func toPreJoin(_ user: Domain.UserModel)
    func toPreJoined(_ user: Domain.UserModel)
    func toApplyedFriend(_ user: Domain.UserModel)
}
