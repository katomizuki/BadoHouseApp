//
//  MakeEventSecondActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/18.
//

import ReSwift
import RxSwift

struct MakeEventSecondActionCreator {
     let userAPI: UserRepositry
     private let disposeBag = DisposeBag()
    
    func getCircle(_ uid: String) {
        userAPI.getMyCircles(uid: uid).subscribe { circle in
//            self?.circleRelay.accept(circle)
        }.disposed(by: disposeBag)
        
        UserRepositryImpl.getUserById(uid: uid) { user in
//            self.user = user
        }
    }
}
