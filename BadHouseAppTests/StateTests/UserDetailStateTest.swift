//
//  UserDetailStateTest.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/14.
//

import ReSwift
@testable import BadHouseApp
import Quick
import Nimble
class UserDetailStateTest: QuickSpec {
    override func spec() {
        
        let appStore = Store(reducer: appReduce, state: AppState())
        
        let beforeReload = appStore.state.userDetailState.reloadStatus
        let beforeError = appStore.state.userDetailState.errorStatus
        let beforeUsers = appStore.state.userDetailState.users
        let beforeCircles = appStore.state.userDetailState.circles
        let beforeApplies = appStore.state.userDetailState.applies
        let beforeCompleted = appStore.state.userDetailState.completedStatus
        
        describe("User Detail State") {
            context("before") {
                it("reload false") {
                    expect(beforeReload).to(beFalse())
                }
                it("error false") {
                    expect(beforeError).to(beFalse())
                }
                it("users count 0") {
                    expect(beforeUsers).to(haveCount(0))
                }
                it("circles count 0") {
                    expect(beforeCircles).to(haveCount(0))
                }
                it("applies count 0") {
                    expect(beforeApplies).to(haveCount(0))
                }
                it("completed false") {
                    expect(beforeCompleted).to(beFalse())
                }
            }
            
            appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(true))
            appStore.dispatch(UserDetailState.UserDetailAction.changeReloadStatus(true))
            appStore.dispatch(UserDetailState.UserDetailAction.setApplies([Apply(dic: ["":""])]))
            appStore.dispatch(UserDetailState.UserDetailAction.setCircles([Circle(dic: ["":""])]))
            appStore.dispatch(UserDetailState.UserDetailAction.setUsers([User(dic: ["":""])]))
            appStore.dispatch(UserDetailState.UserDetailAction.changeCompletedStatus(true))
            
            let afterReload = appStore.state.userDetailState.reloadStatus
            let afterError = appStore.state.userDetailState.errorStatus
            let afterUsers = appStore.state.userDetailState.users
            let afterCircles = appStore.state.userDetailState.circles
            let afterApplies = appStore.state.userDetailState.applies
            let afterCompleted = appStore.state.userDetailState.completedStatus
            
            context("after") {
                it("reload true") {
                    expect(afterReload).to(beTrue())
                }
                it("error true") {
                    expect(afterError).to(beTrue())
                }
                it("users count 0") {
                    expect(afterUsers).to(haveCount(1))
                }
                it("circles count 0") {
                    expect(afterCircles).to(haveCount(1))
                }
                it("applies count 0") {
                    expect(afterApplies).to(haveCount(1))
                }
                it("completed true") {
                    expect(afterCompleted).to(beTrue())
                }
            }
        }
    }
}
