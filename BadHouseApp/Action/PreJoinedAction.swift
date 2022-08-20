//
//  PreJoinedAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//

import ReSwift
import Domain

extension PreJoinedState {
    enum PreJoinedAction: ReSwift.Action {
        case setPrejoinedList(_ list: [Domain.PreJoined])
        case setNavigationTitle(_ title: String)
        case changeReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
