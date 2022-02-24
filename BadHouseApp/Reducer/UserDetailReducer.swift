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
        
        return state
    }
}
