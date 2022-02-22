//
//  PreJoinedState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//

import ReSwift

struct PreJoinedState: StateType {
    var preJoinedList = [PreJoined]()
    var navigationTitle = String()
    var reloadStatus = false
    var errorStatus = false
    var completedStatus = false
}
