//
//  BlockListState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct BlockListState: StateType {
    var users = [User]()
    var reloadStatus = false
}
