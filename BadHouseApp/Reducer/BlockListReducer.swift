//
//  BlockListReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct BlockListReducer {
    static func reducer(action: ReSwift.Action, state: BlockListState?) -> BlockListState {
        var state  = state ?? BlockListState()
        guard let action = action as? BlockListState.BlockListAction else { return state }
        switch action {
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .setUsers(let users):
            state.users = users
        }
        return state
    }
}
