//
//  CircleDetailStateAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Domain

extension CircleDetailState {
    enum CircleDetailAction: ReSwift.Action {
        case setAllMembers(_ users: [Domain.UserModel])
        case setCircle(_ circle: Domain.CircleModel)
        case setFriendsMembers(_ members: [Domain.UserModel])
        case changeErrorStatus(_ isError: Bool)
        case changeReloadStatus(_ isReload: Bool)
    }
}
