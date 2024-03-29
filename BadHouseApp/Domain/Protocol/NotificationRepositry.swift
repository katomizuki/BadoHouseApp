//
//  NotificationRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol NotificationRepositry {
    func getMyNotification(uid: String) -> Single<[Domain.Notification]>
}
