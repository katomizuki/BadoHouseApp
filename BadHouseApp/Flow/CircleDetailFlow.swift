//
//  CircleDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol CircleDetailFlow {
    func toUserDetail(user: Domain.UserModel?,
                      myData: Domain.UserModel)
    func toInvite(circle: Domain.CircleModel,
                  myData: Domain.UserModel)
    func toUpdate(circle: Domain.CircleModel)
}
