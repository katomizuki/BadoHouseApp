//
//  PracticeDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

protocol PracticeDetailFlow {
    func toCircleDetail(myData: User, circle: Circle)
    func toUserDetail(myData: User, user: User)
    func toChat(myData: User, user: User)
}
