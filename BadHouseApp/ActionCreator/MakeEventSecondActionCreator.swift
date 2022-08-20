//
//  MakeEventSecondActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift
import Domain
// infra層がここにあるの良くない
import Infra

struct MakeEventSecondActionCreator {
     let userAPI: any UserRepositry
     private let disposeBag = DisposeBag()
    
    func getCircle(_ uid: String) {
        userAPI.getMyCircles(uid: uid).subscribe { circle in
            appStore.dispatch(MakeEventSecondState.MakeEventSecondAction.setCircle(circle))
        }.disposed(by: disposeBag)
        
        UserRepositryImpl.getUserById(uid: uid) { user in
            appStore.dispatch(MakeEventSecondState.MakeEventSecondAction.setUser(user))
        }
    }
}
