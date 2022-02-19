//
//  NotificationReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct NotificationReducer {
    static func reducer(action: ReSwift.Action, state: NotificationStatus?) -> NotificationStatus {
        var state = state ?? NotificationStatus()
        guard let action = action as? NotificationStatus.NotificationAction else { return state }
        switch action {
        case .setNotifications(let notifications):
            state.notifications = notifications
        case .chageErrorStatus(let isError):
            state.errorStatus = isError
        }
        return state
    }
}
