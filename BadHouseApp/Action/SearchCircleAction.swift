//
//  SearchCircleAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
extension SearchCircleState {
    enum SearchCircleAction: ReSwift.Action {
        case setCircles(_ circles: [Circle])
        case changeErrorStatus(_ isError: Bool)
    }
}
