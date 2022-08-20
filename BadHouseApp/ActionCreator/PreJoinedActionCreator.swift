//
//  PreJoinedActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/22.
//
import RxSwift
import Domain
// infra層がここにあるの良くない
import Infra

struct PreJoinedActionCreator {
    
    let joinAPI: any Domain.JoinRepositry
    private let disposeBag = DisposeBag()
    
    func getPreJoined(user: Domain.UserModel) {
        joinAPI.getPreJoined(userId: user.uid)
            .subscribe { prejoineds in
            appStore.dispatch(PreJoinedState.PreJoinedAction.setPrejoinedList(prejoineds))
            appStore.dispatch(PreJoinedState.PreJoinedAction.setNavigationTitle("\(prejoineds.count)人から参加申請が来ています"))
            appStore.dispatch(PreJoinedState.PreJoinedAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(PreJoinedState.PreJoinedAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func getUser(preJoined: Domain.PreJoined,
                 user: Domain.UserModel,
                 list: [Domain.PreJoined]) {
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
    
    func deletePreJoinedData(_ preJoined: Domain.PreJoined) {
        // ここ変える
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoined.fromUserId, subCollectionName: R.Collection.Users, subId: preJoined.uid)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoined.uid, subCollectionName: R.Collection.Users, subId: preJoined.fromUserId)
    }
}
