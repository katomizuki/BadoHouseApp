//
//  MainStateActionCreators.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
import RxSwift
import FirebaseAuth
struct HomeActionCreator {
    
    let practiceAPI: PracticeRepositry
    private let disposeBag = DisposeBag()
    
    func saveFriend() {
        if let uid =  Auth.auth().currentUser?.uid {
            UserService.saveFriendId(uid: uid)
        }
    }
    
    func getPractices() {
        appStore.dispatch(HomeState.HomeStateAction.changeIndicatorStatus(true))
        appStore.dispatch(HomeState.HomeStateAction.changeRefreshStatus(true))
        practiceAPI.getPractices().subscribe { practices in
            appStore.dispatch(HomeState.HomeStateAction.setPractices(practices))
            appStore.dispatch(HomeState
                             .HomeStateAction
                             .changeIndicatorStatus(false))
            appStore.dispatch(HomeState
                              .HomeStateAction
                              .changeRefreshStatus(false))
            appStore.dispatch(HomeState
                                .HomeStateAction
                                .reload)
            appStore.dispatch(HomeState
                                .HomeStateAction
                                .reload)
        } onFailure: { error in
            appStore.dispatch(HomeState.HomeStateAction
                                .chageErrorStatus(error))
        }.disposed(by: disposeBag)
    }
}
