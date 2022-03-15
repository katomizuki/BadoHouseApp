//
//  TalkActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import RxSwift

struct TalkActionCreator {
    
    let userAPI: any UserRepositry
    private let disposeBag = DisposeBag()
    
    func getChatRooms(uid: String) {
        userAPI.getMyChatRooms(uid: uid).subscribe { chatRooms in
            appStore.dispatch(TalkState.TalkAction.setTalk(chatRooms))
            appStore.dispatch(TalkState.TalkAction.changeReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(TalkState.TalkAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    func toggleError() {
        appStore.dispatch(TalkState.TalkAction.changeErrorStatus(false))
    }
    func toggleReload() {
        appStore.dispatch(TalkState.TalkAction.changeReloadStatus(false))
    }
}
