//
//  TalkAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
extension TalkState {
    enum TalkAction: ReSwift.Action {
        case setTalk(_ talk: [ChatRoom])
        case changeErrorStatus(_ isError: Bool)
        case changeReloadStatus(_ isReload: Bool)
    }
}
