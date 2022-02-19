//
//  MyPracticeReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct MyPracticeReducer {
    static func reducer(action: ReSwift.Action, state: MyPracticeState?) -> MyPracticeState {
        var state = state ?? MyPracticeState()
        guard let action = action as? MyPracticeState.MyPracticeAction else { return state }
        switch action {
        case .setPractice(let practices):
            state.practices = practices
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        }
        return state
    }
}
