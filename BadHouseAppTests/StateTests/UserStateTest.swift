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
class CircleDetailStateTests: QuickSpec {
    override func spec() {
        
        let appStore = Store(reducer: appReduce, state: AppState())
        let beforeReload = appStore.state.circleDetailState.reloadStatus
        let beforeError = appStore.state.circleDetailState.errorStatus
        let beforeCircle = appStore.state.circleDetailState.circle
        let beforeFriends = appStore.state.circleDetailState.friendsMembers
        let beforeMembers = appStore.state.circleDetailState.allMembers
        
        describe("Circle Detail State") {
            context("Before") {
                it("reload false") {
                    expect(beforeReload).to(beFalse())
                }
                it("error false") {
                    expect(beforeError).to(beFalse())
                }
                it ("circle nil") {
                    expect(beforeCircle).to(beNil())
                }
                it ("friend count 0") {
                    expect(beforeFriends).to(haveCount(0))
                }
                it("members count 0") {
                    expect(beforeMembers).to(haveCount(0))
                }
            }
            
            // MARK: - AfterAction
            let users = [User(dic: ["":""]), User(dic: ["":""])]
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeReloadStatus(true))
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeErrorStatus(true))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setAllMembers(users))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setCircle(Circle(dic: ["":""])))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setFriendsMembers(users))
            
            // MARK: - AfterStatus
            
            let afterReload = appStore.state.circleDetailState.reloadStatus
            let afterError = appStore.state.circleDetailState.errorStatus
            let afterCircle = appStore.state.circleDetailState.circle
            let afterAllMembers = appStore.state.circleDetailState.allMembers
            let afterFriends = appStore.state.circleDetailState.friendsMembers
            
            context("After") {
                it ("reload true") {
                    expect(afterReload).to(beTrue())
                }
                it ("error true") {
                    expect(afterError).to(beTrue())
                }
                it ("members haveCount 2") {
                    expect(afterAllMembers).to(haveCount(2))
                }
                it("friends haveCount 2") {
                    expect(afterFriends).to(haveCount(2))
                }
                it("circle notNil") {
                    expect(afterCircle).notTo(beNil())
                }
            }
            
        }
        
    }
}
