//
//  UpdateCircleActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift
import Domain

struct UpdateCircleActionCreator {
    
    private let disposeBag = DisposeBag()
    let circleAPI: any Domain.CircleRepositry

    func saveCircleAction(_ circle: Domain.CircleModel) {
        circleAPI.updateCircle(circle: circle)
            .subscribe(onCompleted: {
            appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(true))
        }, onError: { _ in
            appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(true))
        }).disposed(by: disposeBag)
    }
    
    func toggleError() {
        appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(false))
    }
    
    func toggleCompleted() {
        appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(false))
    }
}
