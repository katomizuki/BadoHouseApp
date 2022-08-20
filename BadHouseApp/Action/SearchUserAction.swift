//
//  SearchUserAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension SearchUserState {
    enum SearchUserAction: ReSwift.Action {
        case setUsers(_ users: [Domain.UserModel])
        case changeErrorStatus(_ isError: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
