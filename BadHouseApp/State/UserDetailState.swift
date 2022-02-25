//
//  UserDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct UserDetailState: StateType {
    var errorStatus = false
    var reloadStatus = false
    var users = [User]()
    var applies = [Apply]()
    var circles = [Circle]()
    var applyButtonTitle = String()
    var notApplyedCompleted = false
    var completedStatus = false
}
