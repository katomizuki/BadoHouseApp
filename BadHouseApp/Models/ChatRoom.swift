//
//  ChatRoom.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/03.
//

import Firebase

struct ChatRoom {
    let id:String
    let latestMessage:String
    let latestTime:Timestamp
    let partnerName:String
    let partnerUrlString:String
}
