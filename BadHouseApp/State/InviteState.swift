//
//  InviteState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct InviteState: StateType {
    var friends = [User]()
    var errorStatus = false
    var completedStatus = false
}
