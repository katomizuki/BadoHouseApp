//
//  InviteState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

struct InviteState: StateType {
    var friends = [Domain.UserModel]()
    var errorStatus = false
    var completedStatus = false
}
