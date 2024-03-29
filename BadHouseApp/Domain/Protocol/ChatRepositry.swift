//
//  ChatRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

public protocol ChatRepositry {
    func getChat(chatId: String) -> Single<[Domain.ChatModel]>
    func postChat(chatId: String,
                  dic: [String: Any]) -> Completable
}
