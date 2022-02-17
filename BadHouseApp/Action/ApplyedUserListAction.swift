//
//  ApplyedUserListAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

extension ApplyedUserListState {
    enum ApplyedUserListStateAction: ReSwift.Action {
        case setApplies(_ applied: [Applyed])
        case changeReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
        case setNavigationTitle(_ title: String)
        case setFriendName(_ name: String)
    }
}
