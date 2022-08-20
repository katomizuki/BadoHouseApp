//
//  UserActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift
import Foundation
import Domain
// infra層がここにあるの良くない
import Infra

struct UserActionCreator {
    private let disposeBag: DisposeBag = DisposeBag()
    let userAPI: any Domain.UserRepositry
    let applyAPI: any Domain.ApplyRepositry
    let circleAPI: any Domain.CircleRepositry
    
    func getUser(uid: String) {
        userAPI.getUser(uid: uid)
            .subscribe(onSuccess: { user in
            appStore.dispatch(UserState.UserAction.setUser(user))
            self.bindCircles(user: user)
            self.bindApplyedUser(user: user)
            self.bindFriends(user: user)
            if let url: URL = URL(string: user.profileImageUrlString) {
                appStore.dispatch(UserState.UserAction.setUserURL(url))
            } else {
                appStore.dispatch(UserState.UserAction.setUserURL(nil))
            }
        }, onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
    
    func saveFriendId(uid: String) {
        UserRepositryImpl.saveFriendId(uid: uid)
    }
    
    private func bindApplyedUser(user: Domain.UserModel) {
        applyAPI.getApplyedUser(user: user)
            .subscribe { applyed in
            appStore.dispatch(UserState.UserAction.changeApplyViewHidden(applyed.count == 0))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: self.disposeBag)
    }
    
    private func bindFriends(user: Domain.UserModel) {
        userAPI.getFriends(uid: user.uid)
            .subscribe { users in
            appStore.dispatch(UserState.UserAction.setUserFriendsCountText("バド友　\(users.count)人"))
            appStore.dispatch(UserState.UserAction.setFriends(users))
            appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    private func bindCircles(user: Domain.UserModel) {
        userAPI.getMyCircles(uid: user.uid)
            .subscribe { circles in
            appStore.dispatch(UserState.UserAction.setUserCircleCountText("所属サークル　\(circles.count)個"))
            appStore.dispatch(UserState.UserAction.setCircle(circles))
            appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }

    func withDrawCircle(user: Domain.UserModel,
                        circle: Domain.CircleModel,
                        circles: [Domain.CircleModel]) {
        circleAPI.withdrawCircle(user: user,
                                 circle: circle)
            .subscribe(onCompleted: {
                appStore.dispatch(UserState.UserAction.setCircle(circles))
                appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
        }, onError: { _ in
            appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
    
    func deleteCircle(user: Domain.UserModel,
                      circle: Domain.CircleModel) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users,
                                              documentId: user.uid,
                                              subCollectionName: R.Collection.Circle,
                                              subId: circle.id)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(UserState.UserAction.changeErrorStatus(true))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(UserState.UserAction.changeReloadStatus(false))
    }
    
    func setFriends(_ users: [Domain.UserModel]) {
        appStore.dispatch(UserState.UserAction.setFriends(users))
        appStore.dispatch(UserState.UserAction.changeReloadStatus(true))
    }
    
    func updateBlockIds(user: Domain.UserModel) {
        var array: [String] = Infra.UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.blocks)
        array.append(user.uid)
        Infra.UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.blocks)
    }
    
    func saveBlocksIds(user: Domain.UserModel) {
        Infra.UserDefaultsRepositry.shared.saveToUserDefaults(element: [user.uid], key: R.UserDefaultsKey.blocks)
    }
   
}
