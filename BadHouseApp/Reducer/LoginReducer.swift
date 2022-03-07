//
//  LoginReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/07.
//

import ReSwift

struct LoginReducer {
    static func reducer(action: ReSwift.Action, state: LoginState?) -> LoginState {
        var state = state ?? LoginState()
        guard let action = action as? LoginState.LoginAction else { return state }
       
        return state
    }
}
