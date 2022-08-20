//
//  ApplyFriendsActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift
import Domain

struct ApplyFriendsActionCreator {
    let applyAPI: any ApplyRepositry
    private let disposeBag = DisposeBag()
    
    func getApplyData(_ user: Domain.UserModel) {
        applyAPI.getApplyUser(user: user).subscribe { applies in
            appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.setApplies(applies))
            appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func onTrashButton(apply: Domain.ApplyModel,
                       uid: String,
                       list: [Domain.ApplyModel]) {
        applyAPI.notApplyFriend(uid: uid,
                                toUserId: apply.toUserId)
        let value = list.filter {
            $0.toUserId != apply.toUserId
        }
        appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.setApplies(value))
        appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.changeReloadStatus(true))
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(ApplyFriendsState.ApplyFriendsAction.changeReloadStatus(false))
    }
}
