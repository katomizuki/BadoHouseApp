//
//  PreJoinedReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//

import ReSwift

struct PreJoinedReducer {
    static func reducer(action: ReSwift.Action, state: PreJoinedState?) -> PreJoinedState {
        var state = state ?? PreJoinedState()
        guard let action = action as? PreJoinedState.PreJoinedAction else { return state }
        switch action {
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .setNavigationTitle(let title):
            state.navigationTitle = title
        case .setPrejoinedList(let list):
            state.preJoinedList = list
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        }
        return state
    }

}
