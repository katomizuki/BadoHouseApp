//
//  UserDetailAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension UserDetailState {
    enum UserDetailAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case setApplies(_ applyList: [Domain.ApplyModel])
        case setUsers(_ users: [Domain.UserModel])
        case setCircles(_ circles: [Domain.CircleModel])
        case changeReloadStatus(_ isReload: Bool)
        case setApplyButtonTitle(_ title: String)
        case changeNotApplyedStatus(_ isApplyed: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
