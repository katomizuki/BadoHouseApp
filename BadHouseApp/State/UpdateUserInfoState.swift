//
//  UpdateUserInfoState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct UpdateUserInfoState: StateType {
    var user: User?
    var errorStatus = false
    var reloadStatus = false
    var completedStatus = false
}
