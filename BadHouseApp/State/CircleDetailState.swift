//
//  CircleDetailState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct CircleDetailState: StateType {
    var allMembers = [User]()
    var circle: Circle?
    var friendsMembers = [User]()
    var errorStatus = false
    var reloadStatus = false
}
