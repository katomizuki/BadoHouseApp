//
//  InviteAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

extension InviteState {
    enum InviteAction:ReSwift.Action {
        case setFriends(_ friends: [User])
        case changeErrorStatus(_ isError: Bool)
        case chageCompletedStatus(_ isCompleted: Bool)
    }
}
