//
//  TalkState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift
import Domain

struct TalkState: StateType {
    var talks = [Domain.ChatRoom]()
    var errorStatus = false
    var reloadStauts = false
}
