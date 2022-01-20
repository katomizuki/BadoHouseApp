//
//  PracticeGetPreJoinTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct PracticeGetPreJoinTargetType: FirebaseSubCollectionTargetType {
    var isDescending: Bool?
    var id: String
    var ref: CollectionReference { Ref.PreJoinRef }
    
    var subRef: CollectionReference { Ref.PreJoinRef }
    
    var subCollectionName: String { "Users"}
    typealias Model = PreJoin
}
