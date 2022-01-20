//
//  PracticeGetTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct PracticeGetTargetType: FirebaseTargetType {
    var id: String = ""
    
    var ref: CollectionReference { Ref.PracticeRef }
    
    typealias Model = Practice
}
