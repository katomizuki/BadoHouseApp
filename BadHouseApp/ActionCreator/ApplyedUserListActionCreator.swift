//
//  ApplyedUserListActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import Foundation
import RxSwift

struct ApplyedUserListActionCreator {
    let applyAPI: any ApplyRepositry
    private let disposeBag = DisposeBag()
    
    func saveId(id: String) {
        if isExistsUserDefaults() {
            let array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.friends)
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [id], key: R.UserDefaultsKey.friends)
        }
    }
    
    private func isExistsUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: R.UserDefaultsKey.friends) != nil
    }
    
    func deleteFriends(_ applyed: Applyed, uid: String, list: [Applyed]) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId, toUserId: uid)
        let value = list.filter { $0.fromUserId != applyed.fromUserId }
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.setApplies(value))
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeReloadStatus(true))
    }
    
    func getApplyedUserList(_ user: User) {
        applyAPI.getApplyedUser(user: user)
            .subscribe { value in
            appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.setApplies(value))
            appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.setNavigationTitle("\(value.count)人から友達申請が来ています"))
            appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func makeFriends(_ applyed: Applyed, uid: String, list: [Applyed], user: User) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId,
                                    toUserId: uid)
        let value = list.filter { $0.fromUserId != applyed.fromUserId }
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.setApplies(value))
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeReloadStatus(true))
        self.match(applyed: applyed, user: user)
    }
    
    private func match(applyed: Applyed, user: User) {
        UserRepositryImpl.getUserById(uid: applyed.fromUserId) { friend in
            self.applyAPI
                .match(user: user,
                       friend: friend).subscribe {
                    appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.setFriendName(applyed.name))
                    self.saveId(id: applyed.fromUserId)
            } onError: { _ in
                appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeErrorStatus(true))
            }.disposed(by: self.disposeBag)
        }
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(ApplyedUserListState.ApplyedUserListStateAction.changeReloadStatus(false))
    }
}
