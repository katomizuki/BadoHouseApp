//
//  MainReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift

struct HomeReducer {
    static func reducer(action: ReSwift.Action, state: HomeState?) -> HomeState {
        var state = state ?? HomeState()
        guard let action = action as? HomeState.HomeStateAction else { return state }
        switch action {
        case .setPractices(let practices):
            state.practices = practices
        }
        return state
    }
}
