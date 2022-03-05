//
//  MainAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
extension HomeState {
    enum HomeStateAction: ReSwift.Action {
        case setPractices(_ practies: [Practice])
        case setUser(_ user: User)
        case changeIndicatorStatus(_ isAnimating: Bool)
        case changeRefreshStatus(_ isAnimating: Bool)
        case chageErrorStatus(_ error: Error)
        case changeReloadStatus(_ isReload: Bool)
    }
}
