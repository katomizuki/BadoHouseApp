//
//  UpdateUserInfoReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct UpdateUserInfoReducer {
    static func reducer(action: ReSwift.Action, state: UpdateUserInfoState?) -> UpdateUserInfoState {
        var state = state ?? UpdateUserInfoState()
        guard let action = action as? UpdateUserInfoState.UpdateUserInfoAction else { return state }
        switch action {
        case .setUser(let user):
            state.user = user
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .changeCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        }
        return state
    }
}
