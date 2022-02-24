//
//  PrejoinReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct PreJoinReducer {
    static func reducer(action: ReSwift.Action, state: PreJoinState?) -> PreJoinState {
        var state = state ?? PreJoinState()
        guard let action = action as? PreJoinState.PreJoinAction else { return state }
        
        return state
    }

}
