//
//  ChatAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

extension ChatState {
    
    enum ChatAction: ReSwift.Action {
        case setChatList(_ chat: [Chat])
        case chageReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
        case setChatId(_ chatId: String)
    }
}
