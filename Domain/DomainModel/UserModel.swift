//
//  UserModel.swift
//  Domain
//
//  Created by ミズキ on 2022/08/18.
//

import Foundation
import FirebaseFirestore

public struct UserModel: Equatable {
    
    public var uid: String
    public var name: String
    public var email: String
    public var createdAt: Timestamp
    public var updatedAt: Timestamp
    public var introduction: String
    public var profileImageUrlString: String
    public var level: String
    public var gender: String
    public var place: String
    public var badmintonTime: String
    public var age: String
    public var racket: String
    public var player: String
    public var profileImageUrl: URL? {
        if let url = URL(string: profileImageUrlString) {
            return url
        } else {
            return nil
        }
    }
    public var isMyself: Bool
    
    public init(uid: String,
         name: String,
         email: String,
         createdAt: Timestamp,
         updatedAt: Timestamp,
         introduction: String,
         profileImageUrlString: String,
         level: String,
         gender: String,
         place: String,
         badmintonTime: String,
         age: String,
         racket: String,
         player: String,
         isMyself: Bool) {
        self.uid = uid
        self.name = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.introduction = introduction
        self.profileImageUrlString = profileImageUrlString
        self.level = level
        self.gender = gender
        self.place = place
        self.age = age
        self.racket = racket
        self.player = player
        self.isMyself = isMyself
        self.badmintonTime = badmintonTime
        self.email = email
    }
}
