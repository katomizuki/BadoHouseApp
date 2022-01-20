//
//  UserGetFriendsTargeType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct UserGetFriendsTargeType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool?
    
    typealias Model = User
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference
    
    var subCollectionName: String
    
}

