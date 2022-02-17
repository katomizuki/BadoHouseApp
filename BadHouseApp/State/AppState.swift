//
//  AppState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift

struct AppState: ReSwift.StateType {
    var homeState = HomeState()
    var additionalMember = AdditionalMemberState()
    var blockListState = BlockListState()
    var applyFriendsState = ApplyFriendsState()
}
