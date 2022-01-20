//
//  UserGetJoinPracticeTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct UserGetJoinPracticeTargetType: FirebaseSubCollectionTargetType {

    typealias Model = Practice
    var isDescending: Bool?
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference { Ref.PracticeRef }
    
    var subCollectionName: String { "Join" }
    
}
