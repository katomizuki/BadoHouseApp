//
//  PracticeSearchReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//

import ReSwift

struct PracticeSearchReducer {
    static func reducer(action: ReSwift.Action, state: PracticeSearchState?) -> PracticeSearchState {
        var state = state ?? PracticeSearchState()
        return state
    }
}
