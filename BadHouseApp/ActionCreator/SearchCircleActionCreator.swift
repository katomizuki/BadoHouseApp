//
//  SearchCircleActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct SearchCircleActionCreator {
    private let disposeBag = DisposeBag()
    let circleAPI: CircleRepositry
    
    func search(_ text: String) {
        self.circleAPI.searchCircles(text: text).subscribe { circles in
            appStore.dispatch(SearchCircleState.SearchCircleAction.setCircles(circles))
        } onFailure: { _ in
            appStore.dispatch(SearchCircleState.SearchCircleAction.changeErrorStatus(true))
        }.disposed(by: self.disposeBag)
    }
}
