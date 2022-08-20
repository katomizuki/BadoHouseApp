//
//  UserAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Foundation
import Domain

extension UserState {
    enum UserAction: ReSwift.Action {
        case setUserURL(_ url: URL?)
        case changeErrorStatus(_ isErro: Bool)
        case changeReloadStatus(_ isReload: Bool)
        case setUser(_ user: Domain.UserModel)
        case setFriends(_ friends: [Domain.UserModel])
        case setCircle(_ circle: [Domain.CircleModel])
        case setUserFriendsCountText(_ text: String)
        case setUserCircleCountText(_ text: String)
        case changeApplyViewHidden(_ isHidden: Bool)
        case changeUserState(_ isAuth: Bool)
    }
}
