//
//  SearchUserFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol SearchUserFlow {
    func toUserDetail(_ user: Domain.UserModel,
                      _ myData: Domain.UserModel)
}
