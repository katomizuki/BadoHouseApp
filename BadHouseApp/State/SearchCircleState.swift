//
//  SearchCircleState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct SearchCircleState: StateType {
    var circles = [Domain.CircleModel]()
    var errorStatus = false
}
