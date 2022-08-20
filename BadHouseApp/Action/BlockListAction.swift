//
//  BlockListAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

extension BlockListState {
    enum BlockListAction: ReSwift.Action {
        case setUsers(_ users: [Domain.UserModel])
        case changeReloadStatus(_ isReload: Bool)
    }
}
