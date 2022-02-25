//
//  PreJoinAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

extension PreJoinState {
    enum PreJoinAction: ReSwift.Action {
        case setPreJoinList(_ preJoinList: [PreJoin])
        case changeReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
    }
}
