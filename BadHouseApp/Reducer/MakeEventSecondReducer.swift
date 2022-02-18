//
//  MakeEventSecondReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

struct MakeEventSecondReducer {
    static func reducer(action: ReSwift.Action, state: MakeEventSecondState?) -> MakeEventSecondState {
        var state  = state ?? MakeEventSecondState()
        guard let action = action as? MakeEventSecondState.MakeEventSecondAction else { return state }
        switch action {
        case .setUser(let user):
            state.user = user
        case .setCircle(let circle):
            state.circle = circle
        }
        return state
    }

}
