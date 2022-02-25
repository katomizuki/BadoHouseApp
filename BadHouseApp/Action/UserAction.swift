//
//  UserAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Foundation
extension UserState {
    enum UserAction: ReSwift.Action {
        case setUserURL(_ url: URL?)
        case changeErrorStatus(_ isErro: Bool)
        case changeReloadStatus(_ isReload: Bool)
        case setUser(_ user: User)
        case setFriends(_ friends: [User])
        case setCircle(_ circle: [Circle])
        case setUserFriendsCountText(_ text: String)
        case setUserCircleCountText(_ text: String)
        case changeApplyViewHidden(_ isHidden: Bool)
    }
}
