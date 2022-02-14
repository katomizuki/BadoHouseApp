//
//  CircleDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

protocol CircleDetailFlow {
    func toUserDetail(user: User?, myData: User)
    func toInvite(circle: Circle, myData: User)
    func toUpdate(circle: Circle)
}
