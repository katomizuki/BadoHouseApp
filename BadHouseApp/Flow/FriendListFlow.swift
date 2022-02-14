//
//  FriendListFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

protocol FriendListFlow: AnyObject {
    func toUserDetail(myData: User, user: User)
}
