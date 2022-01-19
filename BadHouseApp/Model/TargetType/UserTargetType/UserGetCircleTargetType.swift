//
//  UserSubTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct UserGetCircleTargetType:FirebaseSubCollectionTargetType {
    typealias Model = Circle
    var id: String
    
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference
    
    var subCollectionName: String
    
}
