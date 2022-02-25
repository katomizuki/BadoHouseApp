//
//  TalkState.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/24.
//

import ReSwift

struct TalkState: StateType {
    var talks = [ChatRoom]()
    var errorStatus = false
    var reloadStauts = false
}
