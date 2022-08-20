//
//  SearchUserState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct SearchUserState: StateType {
    var users = [Domain.UserModel]()
    var errorStatus = false
    var completedStatus = false
}
