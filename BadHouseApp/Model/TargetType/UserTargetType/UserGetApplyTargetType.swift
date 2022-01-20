//
//  UserGetApplyTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
struct UserGetApplyTargetType: FirebaseSubCollectionTargetType {
    var isDescending: Bool?
    
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.ApplyRef }
    
    var subRef: CollectionReference { Ref.ApplyRef }
    
    var subCollectionName: String { "Users" }
    
    typealias Model = Apply
    
}
