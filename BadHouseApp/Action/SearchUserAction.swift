//
//  SearchUserAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
extension SearchUserState {
    enum SearchUserAction: ReSwift.Action {
        case setUsers(_ users: [User])
        case changeErrorStatus(_ isError: Bool)
        case changeCompletedStatus(_ isCompleted: Bool)
    }
}
