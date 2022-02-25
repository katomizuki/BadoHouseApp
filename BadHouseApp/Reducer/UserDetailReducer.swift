//
//  UserDetailReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct UserDetailReducer {
    static func reducer(action: ReSwift.Action, state: UserDetailState?) -> UserDetailState {
        var state = state ?? UserDetailState()
        guard let action = action as? UserDetailState.UserDetailAction else { return state }
        switch action {
        case .setApplies(let applyList):
            state.applies = applyList
        case .setCircles(let circles):
            state.circles = circles
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .setUsers(let users):
            state.users = users
        case .setApplyButtonTitle(let title):
            state.applyButtonTitle = title
        case .changeNotApplyedStatus(let isApplyed):
            state.notApplyedCompleted = isApplyed
        case .changeCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        }
        return state
    }
}
