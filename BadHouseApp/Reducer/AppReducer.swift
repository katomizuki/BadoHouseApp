//
//  AppReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift

func appReduce(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    state.homeState = HomeReducer.reducer(action: action, state: state.homeState)
    state.additionalMember = AdditionalMemberReducer.reducer(action: action, state: state.additionalMember)
    state.blockListState = BlockListReducer.reducer(action: action, state: state.blockListState)
    state.applyedUserListState = ApplyedUserListReducer.reducer(action: action, state: state.applyedUserListState)
    state.makeEventSecond = MakeEventSecondReducer.reducer(action: action, state: state.makeEventSecond)
    state.circleDetailState = CircleDetailReducer.reducer(action: action, state: state.circleDetailState)
    state.chatState = ChatReducer.reducer(action: action, state: state.chatState)
    state.myPracticeState = MyPracticeReducer.reducer(action: action, state: state.myPracticeState)
    state.inviteState = InviteReducer.reducer(action: action, state: state.inviteState)
    state.notificationStatus = NotificationReducer.reducer(action: action, state: state.notificationStatus)
    state.practiceDetailState = PracticeDetailReducer.reducer(action: action, state: state.practiceDetailState)
    state.practiceSearchState = PracticeSearchReducer.reducer(action: action, state: state.practiceSearchState)
    state.prejoinedState = PreJoinedReducer.reducer(action: action, state: state.prejoinedState)
    state.searchUserState = SearchUserReducer.reducer(action: action, state: state.searchUserState)
    state.searchCircleState = SearchCircleReducer.reducer(action: action, state: state.searchCircleState)
    state.talkState = TalkReducer.reducer(action: action, state: state.talkState)
    state.userState = UserReducer.reducer(action: action, state: state.userState)
    state.userDetailState = UserDetailReducer.reducer(action: action, state: state.userDetailState)
    state.scheduleState = ScheduleReducer.reducer(action: action, state: state.scheduleState)
    state.updateCircleStaet = UpdateCircleReducer.reducer(action: action, state: state.updateCircleStaet)
    state.prejoinState = PreJoinReducer.reducer(action: action, state: state.prejoinState)
    state.updateUserState = UpdateUserInfoReducer.reducer(action: action, state: state.updateUserState)
    state.loginState = LoginReducer.reducer(action: action, state: state.loginState)
    state.registerState = RegisterReducer.reducer(action: action, state: state.registerState)
    state.eventAdditionlItemsState = EventAdditionlItemsReducer.reducer(action: action, state: state.eventAdditionlItemsState)
    return state
}
