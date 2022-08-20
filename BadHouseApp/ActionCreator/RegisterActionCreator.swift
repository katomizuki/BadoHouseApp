//
//  RegisterActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/07.
//
import Domain

struct RegisterActionCreator {
    let authAPI: any Domain.AuthRepositry
    let userAPI: any Domain.UserRepositry
}
