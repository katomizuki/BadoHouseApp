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
    let practiceAPI: PracticeServieProtocol
    private let disposeBag = DisposeBag()
    func saveFriend() {
        if let uid =  Auth.auth().currentUser?.uid {
            UserService.saveFriendId(uid: uid)
        }
    }
    
    func getPractices() {
        practiceAPI.getPractices().subscribe { practices in
            appStore.dispatch(HomeState.HomeStateAction.setPractices(practices))
//            self?.practiceRelay.accept(practices)
//            self?.reload.onNext(())
//            self?.stopIndicator.onNext(())
//            self?.stopRefresh.onNext(())
        } onFailure: { _ in
//            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
}
