//
//  PreJoinModel.swift
//  Domain
//
//  Created by ミズキ on 2022/08/18.
//

import Firebase

public struct PreJoin: Equatable {
    
    public let name: String
    public let id: String
    public let uid: String
    public let practiceName: String
    public let createdAt: Timestamp
    public let imageUrl: String
    public let toUserId: String
    public let circleImage: String
    public var url: URL? {
        if let url = URL(string: imageUrl) {
            return url
        } else {
            return nil
        }
    }
    
    public init(name: String,
                id: String,
                uid: String,
                practiceName: String,
                createdAt: Timestamp,
                imageUrl: String,
                toUserId: String,
                circleImage: String) {
        self.name = name
        self.id = id
        self.uid = uid
        self.practiceName = practiceName
        self.createdAt = createdAt
        self.imageUrl = imageUrl
        self.toUserId = toUserId
        self.circleImage = circleImage
    }
}
