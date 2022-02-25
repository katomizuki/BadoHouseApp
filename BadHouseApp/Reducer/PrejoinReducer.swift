//
//  PrejoinReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct PreJoinReducer {
    static func reducer(action: ReSwift.Action, state: PreJoinState?) -> PreJoinState {
        var state = state ?? PreJoinState()
        guard let action = action as? PreJoinState.PreJoinAction else { return state }
        switch action {
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .setPreJoinList(let preJoinList):
            state.preJoinList = preJoinList
        }
        return state
    }

}
