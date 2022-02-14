//
//  AppReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift

func appReduce(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.homeState = HomeReducer.reducer(action: action, state: state.homeState)
    return state
}
