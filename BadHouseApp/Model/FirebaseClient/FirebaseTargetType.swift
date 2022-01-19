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


