//
//  MainState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
import RxSwift

struct HomeState: StateType {
    var practices: [Practice] = []
    var isIndicatorAnimating = false
    var isRefreshAnimating = false
    var errorStatus: Error?
    var reload = PublishSubject<Void>()
    var user: User?
}
