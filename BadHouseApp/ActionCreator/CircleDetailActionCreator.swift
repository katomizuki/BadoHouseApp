//
//  CircleDetailActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import RxSwift
import Domain

struct CircleDetailActionCreator {
    let circleAPI: any CircleRepositry
    private let disposeBag = DisposeBag()
    
    func getMembers(ids: [String],
                    circle: Domain.CircleModel) {
        circleAPI.getMembers(ids: circle.member,
                             circle: circle).subscribe { circle in
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
    
    func toggleErrorStauts() {
        appStore.dispatch(CircleDetailState.CircleDetailAction.changeErrorStatus(false))
    }
    
    func toggleReloadStaus() {
        appStore.dispatch(CircleDetailState.CircleDetailAction.changeReloadStatus(false))
    }
}
