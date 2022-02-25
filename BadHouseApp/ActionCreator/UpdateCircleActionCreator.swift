//
//  UpdateCircleActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct UpdateCircleActionCreator {
    
    private let disposeBag = DisposeBag()
    let circleAPI: CircleRepositry

    func saveCircleAction(_ circle: Circle) {
        circleAPI.updateCircle(circle: circle).subscribe(onCompleted: {
            appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(true))
        }, onError: { _ in
            appStore.dispatch(UpdateCircleState.UpdateCircleAction.changeCompletedStatus(true))
        }).disposed(by: disposeBag)
    }
}
