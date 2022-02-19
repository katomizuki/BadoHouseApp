//
//  InviteReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct InviteReducer {
    static func reducer(action: ReSwift.Action, state: InviteState?) -> InviteState {
        var state = state ?? InviteState()
        guard let action = action as? InviteState.InviteAction else { return state }
        switch action {
        case .chageCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        case .setFriends(let friends):
            state.friends = friends
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        }
        return state
    }
}
