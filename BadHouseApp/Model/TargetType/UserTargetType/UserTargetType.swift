//
//  UserTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/19.
//

import FirebaseFirestore
struct UserTargetType:FirebaseTargetType {
    typealias Model = User
    var id: String
    var ref:CollectionReference {
        return Ref.UsersRef
    }
}
