//
//  FirebaseTargetType.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/19.
//

import FirebaseFirestore

protocol FirebaseTargetType {
    associatedtype Model:FirebaseModel
    var id:String { get }
    var ref:CollectionReference { get }
}
protocol FirebaseSubCollectionTargetType {
    associatedtype Model:FirebaseModel
    var id:String { get }
    var ref:CollectionReference { get }
    var subCollectionName:String { get }
    var method:GetMethod { get }
}

enum GetMethod {
    case circle
    case user
    func getUser(uid:String,completion:@escaping(User) -> Void) {
         UserService.getUserById(uid: uid, completion: completion)
    }
    func getCircle(circleId:String,completion:@escaping(Circle) -> Void) {
        CircleService.getCircle(id: circleId, completion: completion)
    }
}
