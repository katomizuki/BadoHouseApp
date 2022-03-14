//
//  UserStateTest.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/11.
//

import ReSwift
@testable import BadHouseApp
import Quick
import Nimble
class UserStateTests: QuickSpec {
    override func spec() {
        
        let appStore = Store(reducer: appReduce, state: AppState())
        let beforeReload = appStore.state.userState.reloadStatus
        let beforeError = appStore.state.userState.errorStatus
        let beforeCircles = appStore.state.userState.circles
        let beforeFriends = appStore.state.userState.friends
        let beforeUser = appStore.state.userState.user
        
        describe("User State") {
            context("Before") {
                it("reload false") {
                    expect(beforeReload).to(beFalse())
                }
                it("error false") {
                    expect(beforeError).to(beFalse())
                }
                it("user nil") {
                    expect(beforeUser).to(beNil())
                }
                it("friend count 0") {
                    expect(beforeFriends).to(haveCount(0))
                }
                it("circles count 0") {
                    expect(beforeCircles).to(haveCount(0))
                }
            }
            
            // MARK: - AfterAction
            let users = [User(dic: ["": ""]), User(dic: ["": ""])]
            appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
            appStore.dispatch(UserState.UserAction.setCircle([Circle(dic: ["":""])]))
            appStore.dispatch(UserState.UserAction.setUser(User(dic: ["":""])))
            appStore.dispatch(UserState.UserAction.setFriends(users))
            
            // MARK: - AfterStatus
            
            let afterReload = appStore.state.userState.reloadStatus
            let afterError = appStore.state.userState.errorStatus
            let afterCircles = appStore.state.userState.circles
            let afterFriends = appStore.state.userState.friends
            let afterUser = appStore.state.userState.user
            
            context("After") {
                it("reload true") {
                    expect(afterReload).to(beTrue())
                }
                it("error true") {
                    expect(afterError).to(beTrue())
                }
                it("circles haveCount 2") {
                    expect(afterCircles).to(haveCount(1))
                }
                it("friends haveCount 2") {
                    expect(afterFriends).to(haveCount(2))
                }
                it("user notNil") {
                    expect(afterUser).notTo(beNil())
                }
            }
        }
    }
}
