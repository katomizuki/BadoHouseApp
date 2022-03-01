//
//  PreJoinedActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//
import RxSwift

struct PreJoinedActionCreator {
    let joinAPI: JoinRepositry
    private let disposeBag = DisposeBag()
    
     func getPreJoined(user: User) {
        joinAPI.getPreJoined(userId: user.uid).subscribe { prejoineds in
            appStore.dispatch(PreJoinedState.PreJoinedAction.setPrejoinedList(prejoineds))
            appStore.dispatch(PreJoinedState.PreJoinedAction.setNavigationTitle("\(prejoineds.count)人から参加申請が来ています"))
            appStore.dispatch(PreJoinedState.PreJoinedAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(PreJoinedState.PreJoinedAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func getUser(preJoined: PreJoined, user: User, list: [PreJoined]) {
        appStore.dispatch(PreJoinedState.PreJoinedAction.setPrejoinedList(list))
        UserRepositryImpl.getUserById(uid: preJoined.fromUserId) { friend in
            self.joinAPI.postMatchJoin(preJoined: preJoined,
                                       user: friend,
                                       myData: user)
                .subscribe(onCompleted: {
                    appStore.dispatch(PreJoinedState.PreJoinedAction.changeCompletedStatus(true))
            }, onError: { _ in
                appStore.dispatch(PreJoinedState.PreJoinedAction.changeErrorStatus(true))
            }).disposed(by: self.disposeBag)
        }
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(PreJoinedState.PreJoinedAction.changeReloadStatus(false))
    }
    
    func toggleCompletedStatus() {
        appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeCompletedStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(PreJoinedState.PreJoinedAction.changeReloadStatus(false))
    }
}
