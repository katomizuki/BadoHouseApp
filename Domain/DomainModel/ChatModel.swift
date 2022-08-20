//
//  ChatModel.swift
//  Domain
//
//  Created by ミズキ on 2022/08/18.
//

import FirebaseFirestore

public struct ChatModel: Equatable {
    
    public let senderId: String
    public let text: String
    public let timeString: String
    public let chatId: String
    
    public init(senderId: String,
                text: String,
                timeString: String,
                chatId: String) {
        self.senderId = senderId
        self.text = text
        self.timeString = timeString
        self.chatId = chatId
    }
}
