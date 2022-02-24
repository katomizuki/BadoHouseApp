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
        
        return state
    }
}
