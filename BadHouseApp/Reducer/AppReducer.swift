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
    state.additionalMember = AdditionalMemberReducer.reducer(action: action, state: state.additionalMember)
    state.blockListState = BlockListReducer.reducer(action: action, state: state.blockListState)
    state.applyedUserListState = ApplyedUserListReducer.reducer(action: action, state: state.applyedUserListState)
    state.makeEventSecond = MakeEventSecondReducer.reducer(action: action, state: state.makeEventSecond)
    return state
}
