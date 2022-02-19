//
//  NotificationStatus.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct NotificationStatus: StateType {
    var notifications = [Notification]()
    var errorStatus = false
}
