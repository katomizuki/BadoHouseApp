//
//  UpdateUserInfoState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct UpdateUserInfoState: StateType {
    var user: Domain.UserModel?
    var errorStatus = false
    var reloadStatus = false
    var completedStatus = false
}
