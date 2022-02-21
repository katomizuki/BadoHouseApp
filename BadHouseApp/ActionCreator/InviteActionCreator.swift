//
//  InviteActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift

struct InviteActionCreator {
    let userAPI: UserRepositry
    let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    
    func getFriends(user: User) {
        userAPI.getFriends(uid: user.uid).subscribe { users in
            appStore.dispatch(InviteState.InviteAction.setFriends(users))
        } onFailure: { _ in
            appStore.dispatch(InviteState.InviteAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func makeCircle(user: User, dic: [String: Any], inviteIds: [String]) {

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
   
}
