//
//  MainReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift

struct MainReducer {
    static func reducer(action: ReSwift.Action, state: MainState?) -> MainState {
        var state = state ?? MainState()
        guard let action = action as? MainState.MainStateAction else { return state }
        switch action {
        case .setPractices(let practices):
            print(practices)
        }
        return state
    }
}
