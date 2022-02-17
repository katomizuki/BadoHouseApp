//
//  ApplyedUserListReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
struct ApplyedUserListReducer {
        static func reducer(action: ReSwift.Action, state: ApplyedUserListState?) -> ApplyedUserListState {
            var state  = state ?? ApplyedUserListState()
            guard let action = action as? ApplyedUserListState.ApplyedUserListStateAction else { return state }
            switch action {
            case .changeErrorStatus(let isError):
                state.errorStatus = isError
            case .changeReloadStatus(let isReload):
                state.reloadStatus = isReload
            case .setApplies(let applied):
                state.applied = applied
            case .setNavigationTitle(let title):
                state.navigationTitle = title
            case .setFriendName(let name):
                state.friendName = name
            }
            return state
        }
}
