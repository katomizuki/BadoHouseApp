//
//  SearchUserState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct SearchUserState: StateType {
    var users = [User]()
    var errorStatus = false
    var completedStatus = false
}
