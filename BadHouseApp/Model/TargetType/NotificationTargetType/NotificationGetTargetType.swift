//
//  NotificationGetTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore

struct NotificationGetTargetType:FirebaseSubCollectionTargetType {
    var isDescending: Bool? { true }
    var id: String
    var ref: CollectionReference { Ref.NotificationRef }
    
    var subRef: CollectionReference { Ref.NotificationRef}
    
    var subCollectionName: String { "Notification" }
    
    typealias Model = Notification
}
