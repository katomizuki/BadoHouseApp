//
//  ChatGetTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct ChatGetTargetType:FirebaseSubCollectionTargetType {
    var isDescending: Bool? { false }
    
    var id: String
    
    var ref: CollectionReference { Ref.ChatRef }
    
    var subRef: CollectionReference { Ref.ChatRef }
    
    var subCollectionName: String { "Comment" }
    typealias Model = Chat

}
