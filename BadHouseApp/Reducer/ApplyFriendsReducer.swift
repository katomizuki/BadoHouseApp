//
//  ApplyFriendsReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct ApplyFriendsReducer {
    static func reducer(action: ReSwift.Action, state: ApplyFriendsState?) -> ApplyFriendsState {
        var state  = state ?? ApplyFriendsState()
        guard let action = action as? ApplyFriendsState.ApplyFriendsAction else { return state }
        switch action {
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .setApplies(let applies):
            state.applies = applies
        }
        return state
    }
}
