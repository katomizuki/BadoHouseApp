//
//  MainState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
import RxSwift
import Domain

struct HomeState: StateType {
    var practices: [Domain.Practice] = []
    var isIndicatorAnimating = false
    var isRefreshAnimating = false
    var errorStatus: Error?
    var reloadStatus = false
    var user: Domain.UserModel?
}
