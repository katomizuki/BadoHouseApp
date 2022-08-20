//
//  NotificationActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift
import Domain

struct NotificationActionCreator {
    let notificationAPI: any Domain.NotificationRepositry
    private let disposeBag = DisposeBag()
    
    func getNotification(user: Domain.UserModel) {
    notificationAPI.getMyNotification(uid: user.uid)
            .subscribe { notifications in
        appStore.dispatch(NotificationStatus.NotificationAction.setNotifications(notifications))
    } onFailure: {  _ in
        appStore.dispatch(NotificationStatus.NotificationAction.chageErrorStatus(true))
    }.disposed(by: disposeBag)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(NotificationStatus.NotificationAction.chageErrorStatus(false))
    }
}
