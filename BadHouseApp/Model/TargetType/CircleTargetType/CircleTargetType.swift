//
//  CircleTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/19.
//

import FirebaseFirestore
struct CircleTargetType: FirebaseTargetType {
    typealias Model = Circle
    var id: String
    var ref:CollectionReference {
        return Ref.CircleRef
    }
}
