//
//  RegisterReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/07.
//

import ReSwift

struct RegisterReducer {
    static func reducer(action: ReSwift.Action, state: RegisterState?) -> RegisterState {
        var state = state ?? RegisterState()
        guard let action = action as? RegisterState.RegisterAction else { return state }
       
        return state
    }
}
