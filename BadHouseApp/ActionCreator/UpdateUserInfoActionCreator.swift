//
//  UpdateUserInfoActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//
import RxSwift
import Domain

struct UpdateUserInfoActionCreator {
    let userAPI: any Domain.UserRepositry
    private let disposeBag = DisposeBag()
    
    func getUser(uid: String) {
            userAPI.getUser(uid: uid)
            .subscribe { user in
                appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.setUser(user))
                appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeReloadStatus(true))
            } onFailure: { _ in
                appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeErrorStatus(true))
            }.disposed(by: disposeBag)
    }
    
    func postUser(dic: [String: Any],
                  uid: String) {
        userAPI.postUser(uid: uid,
                         dic: dic)
        .subscribe(onCompleted: {
            appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeCompletedStatus(true))
        }, onError: {  _ in
            appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
    
    func toggleReload() {
        appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeReloadStatus(false))
    }
    func toggleError() {
        appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeErrorStatus(false))
    }
    func toggleCompleted() {
        appStore.dispatch(UpdateUserInfoState.UpdateUserInfoAction.changeCompletedStatus(false))
    }
}
