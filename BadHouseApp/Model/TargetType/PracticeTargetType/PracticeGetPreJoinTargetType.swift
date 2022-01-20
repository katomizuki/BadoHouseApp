//
//  PracticeGetPreJoinTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct PracticeGetPreJoinTargetType: FirebaseTargetType {
    var id: String
    
    var ref: CollectionReference
    
    typealias Model = Practice
    
 
}
