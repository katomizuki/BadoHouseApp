//
//  ScheduleState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct ScheduleState: StateType {
    var reloadStatus = false
    var errorStatus = false
    var practices = [Practice]()
}
