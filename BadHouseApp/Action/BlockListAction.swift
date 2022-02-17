//
//  BlockListAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

extension BlockListState {
    enum BlockListAction: ReSwift.Action {
        case setUsers(_ users: [User])
        case changeReloadStatus(_ isReload: Bool)
    }
}
