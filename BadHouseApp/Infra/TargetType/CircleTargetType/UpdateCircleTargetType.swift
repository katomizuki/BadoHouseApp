//
//  UpdateCircleTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/03.
//
import FirebaseFirestore

struct UpdateCircleTargetType: FirebaseTargetType {
    var id: String
    var ref: CollectionReference { Ref.CircleRef }
    typealias Model = CompletableEntity
}
