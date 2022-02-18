//
//  CircleDetailReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct CircleDetailReducer {
    static func reducer(action: ReSwift.Action, state: CircleDetailState?) -> CircleDetailState {
        var state = state ?? CircleDetailState()
        guard let action = action as? CircleDetailState.CircleDetailAction else { return state }
        switch action {
        case .setFriendsMembers(let members):
            state.friendsMembers = members
        case .setCircle(let circle):
            state.circle = circle
        case .setAllMembers(let allMembers):
            state.allMembers = allMembers
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        }
        return state
    }
}
