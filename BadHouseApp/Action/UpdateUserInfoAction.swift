//
//  UpdateUserInfoAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension UpdateUserInfoState {
    enum UpdateUserInfoAction: ReSwift.Action {
        case setUser(_ user: Domain.UserModel)
        case changeErrorStatus(_ isError: Bool)
        case changeReloadStatus(_ isReload: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
