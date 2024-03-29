//
//  InviteActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift
import Domain

struct InviteActionCreator {
    let userAPI: any Domain.UserRepositry
    let circleAPI: any Domain.CircleRepositry
    private let disposeBag = DisposeBag()
    
    func getFriends(user: Domain.UserModel) {
        userAPI.getFriends(uid: user.uid).subscribe { users in
            appStore.dispatch(InviteState.InviteAction.setFriends(users))
        } onFailure: { _ in
            appStore.dispatch(InviteState.InviteAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func makeCircle(user: Domain.UserModel,
                    dic: [String: Any],
                    inviteIds: [String]) {

        circleAPI.postCircle(id: dic["id"] as? String ?? "",
                                 dic: dic,
                                 user: user,
                                 memberId: inviteIds) { result in
            switch result {
            case .success:
                appStore.dispatch(InviteState.InviteAction.chageCompletedStatus(true))
            case .failure:
                appStore.dispatch(InviteState.InviteAction.changeErrorStatus(true))
            }
        }
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(InviteState.InviteAction.changeErrorStatus(false))
    }
    
    func toggleCompletedStatus() {
        appStore.dispatch(InviteState.InviteAction.chageCompletedStatus(false))
    }
   
}
