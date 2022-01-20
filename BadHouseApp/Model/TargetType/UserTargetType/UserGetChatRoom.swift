//
//  UserGetChatRoomTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct UserGetChatRoomTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool? { true }
    var id: String
    var ref: CollectionReference { Ref.UsersRef }
    var sortField: String = "latestTime"
    var subRef: CollectionReference { Ref.UsersRef }
    
    var subCollectionName: String { "ChatRoom" }
    
    typealias Model = ChatRoom
}
