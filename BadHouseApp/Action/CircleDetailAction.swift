//
//  CircleDetailStateAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift

extension CircleDetailState {
    enum CircleDetailAction: ReSwift.Action {
        case setAllMembers(_ users: [User])
        case setCircle(_ circle: Circle)
        case setFriendsMembers(_ members: [User])
        case changeErrorStatus(_ isError: Bool)
        case changeReloadStatus(_ isReload: Bool)
    }
}
