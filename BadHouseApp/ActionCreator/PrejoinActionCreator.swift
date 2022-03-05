//
//  PrejoinActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct PrejoinActionCreator {
    
    let joinAPI: JoinRepositry
    private let disposeBag = DisposeBag()
    
    func getPreJoin(user: User) {
        joinAPI.getPrejoin(userId: user.uid).subscribe { prejoins in
            appStore.dispatch(PreJoinState.PreJoinAction.setPreJoinList(prejoins))
            appStore.dispatch(PreJoinState.PreJoinAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(PreJoinState.PreJoinAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func delete(_ preJoin: PreJoin, list: [PreJoin]) {
        // TODO: - ここ分けるか、、
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoin.uid, subCollectionName: R.Collection.Users, subId: preJoin.toUserId)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoin.toUserId, subCollectionName: R.Collection.Users, subId: preJoin.uid)
        var prejoins: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.preJoin)
        prejoins.remove(value: preJoin.id)
        UserDefaultsRepositry.shared.saveToUserDefaults(element: prejoins, key: R.UserDefaultsKey.preJoin)
        appStore.dispatch(PreJoinState.PreJoinAction.setPreJoinList(list))
        appStore.dispatch(PreJoinState.PreJoinAction.changeReloadStatus(true))
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(PreJoinState.PreJoinAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(PreJoinState.PreJoinAction.changeReloadStatus(false))
    }
}
