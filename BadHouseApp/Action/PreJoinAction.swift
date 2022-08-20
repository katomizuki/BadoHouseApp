//
//  PreJoinAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension PreJoinState {
    enum PreJoinAction: ReSwift.Action {
        case setPreJoinList(_ preJoinList: [Domain.PreJoin])
        case changeReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
    }
}
