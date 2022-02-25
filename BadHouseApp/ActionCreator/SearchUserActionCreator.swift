//
//  SearchUserActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct SearchUserActionCreator {
    
    let userAPI: UserRepositry
    let applyAPI: ApplyRepositry
    private let disposeBag = DisposeBag()
    
    func search(_ text: String) {
        userAPI.searchUser(text: text).subscribe { users in
            appStore.dispatch(SearchUserState.SearchUserAction.setUsers(users))
        } onFailure: { _ in
            appStore.dispatch(SearchUserState.SearchUserAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func notApplyFriend(_ user: User, myData: User) {
        applyAPI.notApplyFriend(uid: myData.uid, toUserId: user.uid)
    }
    
    func applyFriend(_ user: User, myData: User) {
        applyAPI.postApply(user: myData, toUser: user).subscribe(onCompleted: {
            appStore.dispatch(SearchUserState.SearchUserAction.changeCompletedStatus(true))
        }, onError: { _ in
            appStore.dispatch(SearchUserState.SearchUserAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
}
