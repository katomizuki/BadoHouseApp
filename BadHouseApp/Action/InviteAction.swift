//
//  InviteAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

extension InviteState {
    enum InviteAction: ReSwift.Action {
        case setFriends(_ friends: [Domain.UserModel])
        case changeErrorStatus(_ isError: Bool)
        case chageCompletedStatus(_ isCompleted: Bool)
    }
}
