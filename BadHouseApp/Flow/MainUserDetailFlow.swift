//
//  MainUserDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

protocol MainUserDetailFlow: AnyObject {
    func toCircleDetail(myData: User, circle: Circle)
    func toFriendList(friends: [User], myData: User)
    func toChat(myData: User, user: User)
}
