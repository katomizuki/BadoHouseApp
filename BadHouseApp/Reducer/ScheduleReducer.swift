//
//  ScheduleReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct ScheduleReducer {
    static func reducer(action: ReSwift.Action, state: ScheduleState?) -> ScheduleState {
        var state = state ?? ScheduleState()
        guard let action = action as? ScheduleState.ScheduleAction else { return state }
        switch action {
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .setPractices(let practices):
            state.practices = practices
        }
        return state
    }
}
