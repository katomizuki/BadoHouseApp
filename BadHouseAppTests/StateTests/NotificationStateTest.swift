//
//  NotificationStateTest.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/14.
//

import ReSwift
@testable import BadHouseApp
import Quick
import Nimble
class NotificationStateTest: QuickSpec {
    override func spec() {
        
        let appStore = Store(reducer: appReduce, state: AppState())
        
        let beforeErrorStatus = appStore.state.notificationStatus.errorStatus
        let beforeNotifications = appStore.state.notificationStatus.notifications
        
        describe("Notification") {
            context("before status") {
                it("before error false") {
                    expect(beforeErrorStatus).to(beFalse())
                }
                it("notifications Count 0") {
                    expect(beforeNotifications).to(haveCount(0))
                }
            }
            
            appStore.dispatch(NotificationStatus.NotificationAction.chageErrorStatus(true))
            appStore.dispatch(NotificationStatus.NotificationAction.setNotifications([Notification(dic: ["":""])]))
            let afterError = appStore.state.notificationStatus.errorStatus
            let afterNotifications = appStore.state.notificationStatus.notifications
            context("after status") {
                it("error true") {
                    expect(afterError).to(beTrue())
                }
                it("notifications count 0") {
                    expect(afterNotifications).to(haveCount(1))
                }
            }
        }
        
    }
}
