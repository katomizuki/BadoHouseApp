//
//  ChatState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import ReSwift

struct ChatState: StateType {
    var chatsList = [Chat]()
    var reloadStatus = false
    var errorStatus = false
    var chatId: String?
}
