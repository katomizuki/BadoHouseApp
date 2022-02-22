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
    var applyedUserListState = ApplyedUserListState()
    var makeEventSecond = MakeEventSecondState()
    var circleDetailState = CircleDetailState()
    var chatState = ChatState()
    var myPracticeState = MyPracticeState()
    var inviteState = InviteState()
    var notificationStatus = NotificationStatus()
    var practiceDetailState = PracticeDetailState()
    var practiceSearchState = PracticeSearchState()
}
