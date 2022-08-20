//
//  PreJoinState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct PreJoinState: StateType {
    var preJoinList = [Domain.PreJoin]()
    var reloadStatus = false
    var errorStatus = false
}
