//
//  PreJoined.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import Firebase
struct PreJoined {
    let id: String
    let circleImage: String
    let createdAt: Timestamp
    let fromUserId: String
    let imageUrl: String
    let name: String
    let practiceName: String
    let uid: String
    init(dic: [String: Any]) {
        self.id = dic["id"] as? String ?? ""
        self.circleImage = dic["circleImage"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.fromUserId = dic["fromUserId"] as? String ?? String()
        self.imageUrl = dic["imageUrl"] as? String ?? String()
        self.name = dic["name"] as? String ?? String()
        self.practiceName = dic["practiceName"] as? String ?? String()
        self.uid = dic["uid"] as? String ?? String()
    }
}
