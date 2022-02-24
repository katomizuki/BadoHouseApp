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
    var prejoinedState = PreJoinedState()
    var prejoinState = PreJoinState()
    var searchUserState = SearchUserState()
    var searchCircleState = SearchCircleState()
    var talkState = TalkState()
    var updateCircleStaet = UpdateCircleState()
    var userDetailState = UserDetailState()
    var userState = UserState()
    var scheduleState = ScheduleState()
    var updateUserState = UpdateUserInfoState()
}
