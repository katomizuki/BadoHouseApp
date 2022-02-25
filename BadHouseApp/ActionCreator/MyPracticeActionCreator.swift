//
//  MyPracticeActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift

struct MyPracticeActionCreator {
    let userAPI: UserRepositry
    private let disposeBag = DisposeBag()
    func getMyPractice(user: User) {
        userAPI.getMyPractice(uid: user.uid).subscribe { practices in
            appStore.dispatch(MyPracticeState.MyPracticeAction.setPractice(practices))
        } onFailure: { _ in
            appStore.dispatch(MyPracticeState.MyPracticeAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(MyPracticeState.MyPracticeAction.changeErrorStatus(false))
    }
    
}
