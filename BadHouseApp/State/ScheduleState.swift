//
//  ScheduleState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct ScheduleState: StateType {
    var reloadStatus = false
    var errorStatus = false
    var practices = [Domain.Practice]()
}
