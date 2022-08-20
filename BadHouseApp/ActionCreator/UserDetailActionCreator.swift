//
//  UserDetailActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift
import Domain

struct UserDetailActionCreator {
    private let disposeBag = DisposeBag()
    let userAPI: any Domain.UserRepositry
    let applyAPI: any Domain.ApplyRepositry
    
    func getFriends(user: Domain.UserModel) {
        userAPI.getFriends(uid: user.uid)
            .subscribe { users in
            appStore.dispatch(UserDetailState.UserDetailAction.setUsers(users))
        } onFailure: { _ in
            appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func getMyCircles(user: Domain.UserModel) {
        userAPI.getMyCircles(uid: user.uid)
            .subscribe { circles in
            appStore.dispatch(UserDetailState.UserDetailAction.setCircles(circles))
            appStore.dispatch(UserDetailState.UserDetailAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
                   
    func getApplyUser(myData: Domain.UserModel,
                      user: Domain.UserModel) {
            applyAPI.getApplyUser(user: myData)
            .subscribe { applies in
                appStore.dispatch(UserDetailState.UserDetailAction.setApplies(applies))
                if isExistsAppliesMember(applies: applies,
                                         uid: user.uid) {
                    appStore.dispatch(UserDetailState.UserDetailAction.setApplyButtonTitle(R.buttonTitle.alreadyApply))
                } else {
                    appStore.dispatch(UserDetailState.UserDetailAction.setApplyButtonTitle(R.buttonTitle.apply))
                }
            } onFailure: { _ in
                appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(true))
            }.disposed(by: disposeBag)
        }
    
    private func isExistsAppliesMember(applies: [Domain.ApplyModel],
                                       uid: String) -> Bool {
        return applies.filter({$0.toUserId == uid}).count != 0
    }
                   
    func applyFriend(myData: Domain.UserModel,
                     user: Domain.UserModel) {
            applyAPI.postApply(user: myData,
                               toUser: user)
            .subscribe {
                appStore.dispatch(UserDetailState.UserDetailAction.changeCompletedStatus(true))
            } onError: { _ in
                appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(true))
            }.disposed(by: self.disposeBag)
        }
                   
    func notApplyedFriend(myData: Domain.UserModel,
                          user: Domain.UserModel) {
        applyAPI.notApplyFriend(uid: myData.uid,
                                toUserId: user.uid)
        appStore.dispatch(UserDetailState.UserDetailAction.changeNotApplyedStatus(true))
    }
    
    func toggleCompledStatus() {
        appStore.dispatch(UserDetailState.UserDetailAction.changeCompletedStatus(false))
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(UserDetailState.UserDetailAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(UserDetailState.UserDetailAction.changeReloadStatus(false))
    }
    
    func togglenotApplyedCompleted() {
        appStore.dispatch(UserDetailState.UserDetailAction.changeNotApplyedStatus(false))
    }
}
