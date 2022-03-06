//
//  MainStateActionCreators.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//

import ReSwift
import RxSwift

struct HomeActionCreator {
    
    let practiceAPI: PracticeRepositry
    private let disposeBag = DisposeBag()
    
    func saveFriend() {
        if let uid =  AuthRepositryImpl.getUid() {
            UserRepositryImpl.saveFriendId(uid: uid)
        }
    }
    
    func getUser(id: String) {
        UserRepositryImpl.getUserById(uid: id) { user in
            appStore.dispatch(HomeState.HomeStateAction.setUser(user))
        }
    }
    
    func getPractices() {
        appStore.dispatch(HomeState.HomeStateAction.changeIndicatorStatus(true))
        appStore.dispatch(HomeState.HomeStateAction.changeRefreshStatus(true))
        
        practiceAPI.getPractices().subscribe { practices in
            appStore.dispatch(HomeState.HomeStateAction.setPractices(practices))
            appStore.dispatch(HomeState.HomeStateAction.changeIndicatorStatus(false))
            appStore.dispatch(HomeState.HomeStateAction.changeRefreshStatus(false))
            appStore.dispatch(HomeState.HomeStateAction.changeReloadStatus(true))
        } onFailure: { error in
            appStore.dispatch(HomeState.HomeStateAction.chageErrorStatus(error))
        }.disposed(by: disposeBag)
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(HomeState.HomeStateAction.changeReloadStatus(false))
    }
    
    func saveId(_ id: String) {
        KeyChainRepositry.save(id: id)
    }
}
