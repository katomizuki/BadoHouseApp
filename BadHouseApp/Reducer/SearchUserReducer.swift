//
//  SearchUserReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct SearchUserReducer {
    static func reducer(action: ReSwift.Action, state: SearchUserState?) -> SearchUserState {
        var state = state ?? SearchUserState()
        guard let action = action as? SearchUserState.SearchUserAction else { return state }
        switch action {
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .setUsers(let users):
            state.users = users
        case .changeCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        }
        return state
    }
}
