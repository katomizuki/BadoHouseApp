//
//  FriendListFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol FriendListFlow: AnyObject {
    func toUserDetail(myData: Domain.UserModel,
                      user: Domain.UserModel)
}
