//
//  PracticeGetPreJoinedTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct PracticeGetPreJoinedTargetType: FirebaseSubCollectionTargetType {
    var isDescending: Bool?
    var sortField: String = ""
    var id: String
    
    var ref: CollectionReference { Ref.PreJoinedRef }
    
    var subRef: CollectionReference { Ref.PreJoinedRef }
    
    var subCollectionName: String { "Users"}
    
    typealias Model = PreJoined
}
