//
//  ScheduleActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct ScheduleActionCreator {
    
    private let disposeBag = DisposeBag()
    let userAPI: UserRepositryImpl
    
    func getMyJoinPractice(user: User) {
        userAPI.getMyJoinPractice(user: user).subscribe { practices in
            appStore.dispatch(ScheduleState.ScheduleAction.setPractices(practices))
            appStore.dispatch(ScheduleState.ScheduleAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(ScheduleState.ScheduleAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(ScheduleState.ScheduleAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(ScheduleState.ScheduleAction.changeReloadStatus(false))
    }
}
