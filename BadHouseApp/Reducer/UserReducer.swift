//
//  UserReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct UserReducer {
    static func reducer(action: ReSwift.Action, state: UserState?) -> UserState {
        var state = state ?? UserState()
        guard let action = action as? UserState.UserAction else { return state }
        
        return state
    }
}
