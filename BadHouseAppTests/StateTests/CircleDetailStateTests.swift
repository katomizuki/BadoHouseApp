//
//  CircleDetailStateTests.swift
//  BadHouseAppTests
//
//  Created by ミズキ on 2022/03/09.
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
        let beforeAllMembers = appStore.state.circleDetailState.allMembers
        let beforeFriendsMembers = appStore.state.circleDetailState.friendsMembers
        let am = [User(dic: ["": ""]), User(dic: ["": ""]), User(dic: ["": ""])]
        let fm = [User(dic: ["": ""]), User(dic: ["": ""])]
        describe("CircleDetail Status") {
            context("before") {
                it("it false") {
                    expect(beforeReload).to(equal(false))
                }
                it("it false") {
                    expect(beforeError).to(equal(false))
                }
                it("it []") {
                    expect(beforeAllMembers).to(equal([User]()))
                }
                it("it []") {
                    expect(beforeFriendsMembers).to(equal([User]()))
                }
            }
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeReloadStatus(true))
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeErrorStatus(true))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setAllMembers(am))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setFriendsMembers(fm))
            
            let afterReload = appStore.state.circleDetailState.reloadStatus
            let afterError = appStore.state.circleDetailState.errorStatus
            let afterAllMembers = appStore.state.circleDetailState.allMembers
            let afterFriendsMembers = appStore.state.circleDetailState.friendsMembers
            
            context("after") {
                it("it true") {
                    expect(afterReload).to(equal(true))
                }
                it("it true") {
                    expect(afterError).to(equal(true))
                }
                it("it 3") {
                    expect(afterAllMembers.count).to(equal(3))
                }
                it("it 2") {
                    expect(afterFriendsMembers.count).to(equal(2))
                }
            }
        }
    }
    
}
