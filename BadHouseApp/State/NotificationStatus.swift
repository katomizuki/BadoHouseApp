//
//  NotificationStatus.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

struct NotificationStatus: StateType {
    var notifications = [Domain.Notification]()
    var errorStatus = false
}
