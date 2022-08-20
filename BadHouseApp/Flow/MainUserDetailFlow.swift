//
//  MainUserDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol MainUserDetailFlow: AnyObject {
    func toCircleDetail(myData: Domain.UserModel,
                        circle: Domain.CircleModel)
    func toFriendList(friends: [Domain.UserModel],
                      myData: Domain.UserModel)
    func toChat(myData: Domain.UserModel,
                user: Domain.UserModel)
}
