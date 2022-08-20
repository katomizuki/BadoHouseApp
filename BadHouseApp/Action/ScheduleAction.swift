//
//  ScheduleAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

extension ScheduleState {
    enum ScheduleAction: ReSwift.Action {
        case setPractices(_ practices: [Domain.Practice])
        case changeErrorStatus(_ isError: Bool)
        case changeReloadStatus(_ isError: Bool)
    }
}
