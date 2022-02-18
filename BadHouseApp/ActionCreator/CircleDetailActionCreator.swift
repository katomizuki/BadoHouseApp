//
//  CircleDetailActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift

struct CircleDetailActionCreator {
    let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    
    func test(ids: [String], circle: Circle) {
        circleAPI.getMembers(ids: circle.member, circle: circle).subscribe { circle in
            appStore.dispatch(CircleDetailState.CircleDetailAction.setAllMembers(circle.members))
            appStore.dispatch(CircleDetailState.CircleDetailAction.setCircle(circle))
            let friendsMembers = circle.members.filter({ user in
                 ids.contains(user.uid)
            })
            appStore.dispatch(CircleDetailState.CircleDetailAction.setFriendsMembers(friendsMembers))
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(CircleDetailState.CircleDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
}
