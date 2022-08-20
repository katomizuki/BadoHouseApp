//
//  CompletableEntity.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/03/03.
//

import Domain
struct CompletableEntity: FirebaseModel {
    typealias DomainModel = Domain.CompletableModel
    init(dic: [String : Any]) {
        
    }
    
    func convertToModel() -> Domain.CompletableModel {
        return Domain.CompletableModel()
    }

}
