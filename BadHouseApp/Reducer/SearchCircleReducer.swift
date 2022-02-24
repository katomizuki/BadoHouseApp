//
//  SearchCircleReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct SearchCircleReducer {
    static func reducer(action: ReSwift.Action, state: SearchCircleState?) -> SearchCircleState {
        var state = state ?? SearchCircleState()
        guard let action = action as? SearchCircleState.SearchCircleAction else { return state }
        
        return state
    }
}
