//
//  ApplyFriendsAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//
import ReSwift
extension ApplyFriendsState {
    enum ApplyFriendsAction: ReSwift.Action {
        case setApplies(_ applies: [Apply])
        case changeReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
    }
}
