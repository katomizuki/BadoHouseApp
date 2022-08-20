//
//  ChatAction.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

extension ChatState {
    
    enum ChatAction: ReSwift.Action {
        case setChatList(_ chat: [Domain.ChatModel])
        case chageReloadStatus(_ isReload: Bool)
        case changeErrorStatus(_ isError: Bool)
        case setChatId(_ chatId: String)
    }
}
