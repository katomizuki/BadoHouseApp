//
//  ChatGetTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct ChatGetTargetType:FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool? { false }
    var sortField: String = "createdAt"
    var id: String
    
    var ref: CollectionReference { Ref.ChatRef }
    
    var subRef: CollectionReference { Ref.ChatRef }
    
    var subCollectionName: String { "Comment" }
    typealias Model = Chat

}
