//
//  Notification-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

import FirebaseFirestore
protocol NotificationServiceProtocol {
    func postNotification(uid:String,dic: [String:Any],completion: @escaping(Error?)->Void)
}
struct NotificationService: NotificationServiceProtocol {
    func postNotification(uid: String, dic: [String : Any], completion: @escaping (Error?) -> Void) {
        let id = Ref.NotificationRef.document(uid).collection("Notification").document().documentID
        Ref.NotificationRef.document(uid).collection("Notification").document(id).setData(dic,completion: completion)
    }
}
