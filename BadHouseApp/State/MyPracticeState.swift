//
//  MyPracticeState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

struct MyPracticeState: StateType {
    var practices = [Domain.Practice]()
    var errorStatus = false
}
