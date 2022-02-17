//
//  AdditionalMemberActionReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/17.
//
import ReSwift

struct AdditionalMemberReducer {
    static func reducer(action: ReSwift.Action, state: AdditionalMemberState?) -> AdditionalMemberState {
        var state = state ?? AdditionalMemberState()
        guard let action = action as? AdditionalMemberState.AdditionalMemberAction else { return state }
        switch action {
        case .setMember(let members):
            state.members = members
        case .changeCompledStatus(let isCompleted):
            state.completedStatus = isCompleted
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        }
        return state
    }
}
