//
//  PracticeDetailFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol PracticeDetailFlow {
    func toCircleDetail(myData: Domain.UserModel,
                        circle: Domain.CircleModel)
    func toUserDetail(myData: Domain.UserModel,
                      user: Domain.UserModel)
    func toChat(myData: Domain.UserModel,
                user: Domain.UserModel)
}
