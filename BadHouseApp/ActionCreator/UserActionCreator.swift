//
//  UserActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift
import Foundation

struct UserActionCreator {
    private let disposeBag = DisposeBag()
    let userAPI: UserRepositry
    let applyAPI: ApplyRepositry
    let circleAPI: CircleRepositry
    
    func getUser(uid: String) {
        userAPI.getUser(uid: uid).subscribe(onSuccess: { user in
            appStore.dispatch(UserState.UserAction.setUser(user))
            self.bindCircles(user: user)
            self.bindApplyedUser(user: user)
            self.bindFriends(user: user)
            if let url = URL(string: user.profileImageUrlString) {
                appStore.dispatch(UserState.UserAction.setUserURL(url))
            } else {
                appStore.dispatch(UserState.UserAction.setUserURL(nil))
            }
        }, onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
        
        UserRepositryImpl.saveFriendId(uid: uid)
    }
    
    private func bindApplyedUser(user: User) {
        applyAPI.getApplyedUser(user: user).subscribe { applyed in
            appStore.dispatch(UserState.UserAction.changeApplyViewHidden(applyed.count == 0))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: self.disposeBag)
    }
    
    private func bindFriends(user: User) {
        userAPI.getFriends(uid: user.uid).subscribe { users in
            appStore.dispatch(UserState.UserAction.setUserFriendsCountText("バド友　\(users.count)人"))
            appStore.dispatch(UserState.UserAction.setFriends(users))
            appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    private func bindCircles(user: User) {
        userAPI.getMyCircles(uid: user.uid).subscribe { circles in
            appStore.dispatch(UserState.UserAction.setUserCircleCountText("所属サークル　\(circles.count)個"))
            appStore.dispatch(UserState.UserAction.setCircle(circles))
            appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    func withDrawCircle(user: User, circle: Circle, circles: [Circle]) {
        circleAPI.withdrawCircle(user: user,
                                 circle: circle)
            .subscribe(onCompleted: {
                appStore.dispatch(UserState.UserAction.setCircle(circles))
                appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        }, onError: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(UserState.UserAction.changeReloadStatus(false))
    }
   
}
