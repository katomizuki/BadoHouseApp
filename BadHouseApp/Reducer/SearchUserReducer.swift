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
        
        return state
    }
}
