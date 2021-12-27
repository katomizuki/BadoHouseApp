//
//  Firebase-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/27.
//

import Firebase
protocol FirebaseServiceProtocol {
    func postData(id:String,
                  dic:[String:Any],
                  ref:CollectionReference,
                  completion:@escaping(Result<Void,Error>)->Void)
}
struct FirebaseService: FirebaseServiceProtocol {
    func postData(id:String,
                  dic:[String:Any],
                  ref:CollectionReference,
                  completion:@escaping(Result<Void,Error>)->Void) {
        ref.document(id).setData(dic) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
}
