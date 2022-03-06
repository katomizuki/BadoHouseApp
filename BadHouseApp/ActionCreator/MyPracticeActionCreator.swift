//
//  MyPracticeActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift

struct MyPracticeActionCreator {
    let userAPI: UserRepositry
    private let disposeBag = DisposeBag()

    func getMyPractice(user: User) {
        userAPI.getMyPractice(uid: user.uid).subscribe { practices in
            appStore.dispatch(MyPracticeState.MyPracticeAction.setPractice(practices))
        } onFailure: { _ in
            appStore.dispatch(MyPracticeState.MyPracticeAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(MyPracticeState.MyPracticeAction.changeErrorStatus(false))
    }
    
    func deletePractice(_ practice: Practice, myData: User) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users, documentId: myData.uid, subCollectionName: R.Collection.Practice, subId: practice.id)
        DeleteService.deleteCollectionData(collectionName: R.Collection.Practice, documentId: practice.id)
    }
    
}
