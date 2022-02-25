//
//  UpdateCircleReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct UpdateCircleReducer {
    static func reducer(action: ReSwift.Action, state: UpdateCircleState?) -> UpdateCircleState {
        var state = state ?? UpdateCircleState()
        guard let action = action as? UpdateCircleState.UpdateCircleAction else { return state }
        switch action {
        case .changeCompletedStatus(let isCompleted):
            state.completedStatus = isCompleted
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        }
        
        return state
    }
}
