//
//  ChatState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift
import Domain

struct ChatState: StateType {
    var chatsList = [Domain.ChatModel]()
    var reloadStatus = false
    var errorStatus = false
    var chatId: String?
}
