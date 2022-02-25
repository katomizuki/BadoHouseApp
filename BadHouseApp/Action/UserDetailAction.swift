//
//  UserDetailAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
extension UserDetailState {
    enum UserDetailAction: ReSwift.Action {
        case changeErrorStatus(_ isError: Bool)
        case setApplies(_ applyList: [Apply])
        case setUsers(_ users: [User])
        case setCircles(_ circles: [Circle])
        case changeReloadStatus(_ isReload: Bool)
        case setApplyButtonTitle(_ title: String)
        case changeNotApplyedStatus(_ isApplyed: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
