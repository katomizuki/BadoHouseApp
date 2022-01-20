//
//  PracticeGetTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct PracticeGetTargetType: FirebaseSubCollectionTargetType {
    var id: String
    
    var ref: CollectionReference { Ref.PracticeRef }
    
    var subRef: CollectionReference { R}
    
    var subCollectionName: String
    
    var isDescending: Bool?
    
    typealias Model = Practice
}
