//
//  CircleDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

struct CircleDetailState: StateType {
    var allMembers = [Domain.UserModel]()
    var circle: Domain.CircleModel?
    var friendsMembers = [Domain.UserModel]()
    var errorStatus = false
    var reloadStatus = false
}
