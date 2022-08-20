//
//  TalkFlow.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/14.
//
import Domain

protocol TalkFlow: AnyObject {
    func toChat(userId: String,
                myDataId: String,
                chatId: String)
}
