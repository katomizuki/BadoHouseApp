//
//  FirebaseSubCollection.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/20.
//

import FirebaseFirestore
protocol FirebaseSubCollectionTargetType {
    associatedtype Model:FirebaseModel
    var id:String { get }
    var ref:CollectionReference { get }
    var subRef: CollectionReference { get }
    var subCollectionName:String { get }
    var isDescending:Bool? { get }
}
