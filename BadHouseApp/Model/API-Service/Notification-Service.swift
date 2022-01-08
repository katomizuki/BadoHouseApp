//
//  Notification-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/08.
//

import FirebaseFirestore
import RxSwift
protocol NotificationServiceProtocol {
    func getMyNotification(uid: String)->Single<[Notification]>
}
struct NotificationService: NotificationServiceProtocol {
    
    static func postNotification(uid: String, dic: [String : Any], completion: @escaping (Error?) -> Void) {
        let id = Ref.NotificationRef.document(uid).collection("Notification").document().documentID
        Ref.NotificationRef.document(uid).collection("Notification").document(id).setData(dic,completion: completion)
    }
    func getMyNotification(uid: String) -> Single<[Notification]> {
        var notifications = [Notification]()
        return Single.create { singleEvent -> Disposable in
            Ref.NotificationRef.document(uid).collection("Notification").order(by: "createdAt", descending: true).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let documents = snapShot?.documents else { return }
                notifications = documents.map { Notification(dic: $0.data()) }
                singleEvent(.success(notifications))
            }
            return Disposables.create()
        }
    }
}
