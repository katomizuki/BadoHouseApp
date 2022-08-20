//
//  File.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import RxSwift
import Foundation
import Domain
// infra層がここにあるの良くない
import Infra

struct PracticeActionCreator {
    let userAPI: any Domain.UserRepositry
    let circleAPI: any Domain.CircleRepositry
    let joinAPI: any Domain.JoinRepositry
    private let disposeBag = DisposeBag()
    
    func getUser(uid: String) {
        userAPI.getUser(uid: uid).subscribe {  user in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.setUser(user))
        } onFailure: { _ in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func getCircle(circleId: String) {
        circleAPI.getCircle(id: circleId)
            .subscribe { circle in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.setCircle(circle))
        } onFailure: { _ in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func checkButtonHidden(uid: String,
                           user: Domain.UserModel,
                           isModal: Bool) {
        UserRepositryImpl.getUserById(uid: uid) { myData in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.setMyData(myData))
            if myData.uid == user.uid || isModal == true {
                appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeButtonHiddenStatus(true))
            }
        }
    }
    func takePartInPractice(user: Domain.UserModel,
                            myData: Domain.UserModel,
                            practice: Domain.Practice) {
        joinAPI.postPreJoin(user: myData,
                            toUser: user,
                            practice: practice).subscribe {
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeCompletedStatus(true))
        } onError: { _ in
            appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func saveUserDefaults(practice: Practice) {
        if existsPreJoinId() {
            var array: [String] = Infra.UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.preJoin)
            array.append(practice.id)
            Infra.UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.preJoin)
        } else {
            Infra.UserDefaultsRepositry.shared.saveToUserDefaults(element: [practice.id], key: R.UserDefaultsKey.preJoin)
        }
    }

    private func existsPreJoinId() -> Bool {
        return  UserDefaults.standard.object(forKey: R.UserDefaultsKey.preJoin) != nil
    }

    func toggleErrorStatus() {
        appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeErrorStatus(false))
    }
    func toggleCompletedStatus() {
        appStore.dispatch(PracticeDetailState.PracticeDetailAction.changeCompletedStatus(false))
    }
}
