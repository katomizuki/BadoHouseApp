//
//  PracticeDetailReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct PracticeDetailReducer {
    static func reducer(action: ReSwift.Action, state: PracticeDetailState?) -> PracticeDetailState {
        var state = state ?? PracticeDetailState()
        guard let action = action as? PracticeDetailState.PracticeDetailAction else { return state }
        switch action {
        case .setUser(let user):
            state.user = user
        case .setMyData(let myData):
            state.myData = myData
        case .setCircle(let circle):
            state.circle = circle
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .changeButtonHiddenStatus(let isHidden):
            state.buttonHidden = isHidden
        case .changeCompletedStatus(let completed):
            state.completedStatus = completed
        case .changeTakePartInButtonStatus(let isHidden):
            state.isTakePartInButton = isHidden
        }
        return state
    }
}
