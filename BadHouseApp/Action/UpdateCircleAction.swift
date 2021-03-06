//
//  UpdateCircleAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
extension UpdateCircleState {
    enum UpdateCircleAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
