//
//  UserReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct UserReducer {
    static func reducer(action: ReSwift.Action, state: UserState?) -> UserState {
        var state = state ?? UserState()
        guard let action = action as? UserState.UserAction else { return state }
        switch action {
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .setUserFriendsCountText(let countText):
            state.userFriendsCountText = countText
        case .setCircle(let circles):
            state.circles = circles
        case .setFriends(let friends):
            state.friends = friends
        case .changeApplyViewHidden(let isHidden):
            state.isApplyViewHidden = isHidden
        case .changeReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .setUserCircleCountText(let countText):
            state.userCircleCountText = countText
        case .setUserURL(let url):
            state.userUrl = url
        case .setUser(let user):
            state.user = user
        }
        return state
    }
}
