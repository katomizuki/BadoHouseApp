//
//  ApplyedUserListState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

struct ApplyedUserListState: StateType {
    var applied = [Domain.ApplyedModel]()
    var reloadStatus = false
    var errorStatus = false
    var friendName = String()
    var navigationTitle = String()
}
