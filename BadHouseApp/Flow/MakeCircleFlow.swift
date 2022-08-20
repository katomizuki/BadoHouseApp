//
//  MakeCircleFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain
protocol MakeCircleFlow {
    func toInvite(_ user: Domain.UserModel,
                  form: Form?)
    func pop()
}
