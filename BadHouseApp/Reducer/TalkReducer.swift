//
//  TalkReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
struct TalkReducer {
    static func reducer(action: ReSwift.Action, state: TalkState?) -> TalkState {
        var state = state ?? TalkState()
        guard let action = action as? TalkState.TalkAction else { return state }
        
        return state
    }
}
