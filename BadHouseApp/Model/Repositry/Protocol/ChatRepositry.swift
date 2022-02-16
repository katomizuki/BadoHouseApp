//
//  ChatRepositry.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/15.
//

import RxSwift

protocol ChatRepositry {
    func getChat(chatId: String) -> Single<[Chat]>
    func postChat(chatId: String,
                  dic: [String: Any]) -> Completable
}
