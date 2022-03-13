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
        
    }
}
