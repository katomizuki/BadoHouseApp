//
//  BlockListState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

struct BlockListState: StateType {
    var users = [Domain.UserModel]()
    var reloadStatus = false
}
