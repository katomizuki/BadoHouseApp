//
//  Firebase-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/27.
//

import Firebase
import RxSwift
protocol FirebaseType {
    init(dic: [String:Any])
}
//protocol FirebaseServiceProtocol {
//    func postData(id: String,
//                  dic: [String:Any],
//                  ref: CollectionReference,
//                  completion: @escaping (Error?) -> Void)
//    func postSubDocData(id: String,
//                        dic: [String: Any],
//                        ref: CollectionReference,
//                        subId: String,
//                        subCollectioName: String,
//                        completion:@escaping (Error?) -> Void)
//}
//struct FirebaseService: FirebaseServiceProtocol {
//    
//    func postData(id: String, dic: [String : Any], ref: CollectionReference, completion: @escaping (Error?) -> Void) {
//        ref.document(id).setData(dic,completion: completion)
//    }
//    
//    func postSubDocData(id: String, dic: [String : Any], ref: CollectionReference, subId: String, subCollectioName: String, completion: @escaping (Error?) -> Void) {
//        ref.document(id).collection(subCollectioName).document(subId).setData(dic, completion: completion)
//    }
//}
