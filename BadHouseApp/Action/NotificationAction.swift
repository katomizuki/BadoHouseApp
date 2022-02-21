//
//  NotificationAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

extension NotificationStatus {
    enum NotificationAction: ReSwift.Action {
        case setNotifications(_ notifications: [Notification])
        case chageErrorStatus(_ isError: Bool)
    }
}
