//
//  ChatReducer.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct ChatReducer {
    static func reducer(action: ReSwift.Action, state: ChatState?) -> ChatState {
        var state = state ?? ChatState()
        guard let action = action as? ChatState.ChatAction else { return state }
        switch action {
        case .setChatList(let chats):
            state.chatsList = chats
        case .chageReloadStatus(let isReload):
            state.reloadStatus = isReload
        case .changeErrorStatus(let isError):
            state.errorStatus = isError
        case .setChatId(let chatId):
            state.chatId = chatId
        }
        return state
    }
}
