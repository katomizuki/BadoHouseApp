//
//  PreJoinedState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//

import ReSwift
import Domain

struct PreJoinedState: StateType {
    var preJoinedList = [Domain.PreJoined]()
    var navigationTitle = String()
    var reloadStatus = false
    var errorStatus = false
    var completedStatus = false
}
