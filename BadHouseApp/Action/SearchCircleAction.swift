//
//  SearchCircleAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension SearchCircleState {
    enum SearchCircleAction: ReSwift.Action {
        case setCircles(_ circles: [Domain.CircleModel])
        case changeErrorStatus(_ isError: Bool)
    }
}
