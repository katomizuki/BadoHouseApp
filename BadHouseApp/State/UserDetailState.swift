//
//  UserDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct UserDetailState: StateType {
    var errorStatus = false
    var reloadStatus = false
    var users = [Domain.UserModel]()
    var applies = [Domain.ApplyModel]()
    var circles = [Domain.CircleModel]()
    var applyButtonTitle = String()
    var notApplyedCompleted = false
    var completedStatus = false
}
