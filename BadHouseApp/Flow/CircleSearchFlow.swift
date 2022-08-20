//
//  CircleSearchFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol CircleSearchFlow {
    func toCircleDetail(myData: Domain.UserModel,
                        circle: Domain.CircleModel?)
}
