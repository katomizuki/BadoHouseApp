//
//  PreJoinState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct PreJoinState: StateType {
    var preJoinList = [PreJoin]()
    var reloadStatus = false
    var errorStatus = false
}
