//
//  MainAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
import Domain

extension HomeState {
    enum HomeStateAction: ReSwift.Action {
        case setPractices(_ practies: [Domain.Practice])
        case setUser(_ user: Domain.UserModel)
        case changeIndicatorStatus(_ isAnimating: Bool)
        case changeRefreshStatus(_ isAnimating: Bool)
        case chageErrorStatus(_ error: Error)
        case changeReloadStatus(_ isReload: Bool)
    }
}
