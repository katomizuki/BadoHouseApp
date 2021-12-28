//
//  Apply-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import Firebase

struct ApplyService {
    
    static func postApply(user:User,
                          toUser:User,
                          completion:@escaping(Result<Void, Error>)-> Void) {
        Ref.ApplyRef.document(user.uid).setData(["toUserId": toUser.uid,
                                                 "name": toUser.name,
                                                 "imageUrl": toUser.profileImageUrlString,
                                                 "createdAt": Timestamp()]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            Ref.ApplyedRef.document(toUser.uid).setData(["fromUserId" : user.uid,
                                                         "name" : user.name,
                                                         "imageUrl" : user.profileImageUrlString,
                                                         "createdAt": Timestamp()]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    static func notApplyFriend(uid: String,
                               toUserId: String) {
        DeleteService.deleteCollectionData(collectionName: "Apply", documentId: uid)
        DeleteService.deleteCollectionData(collectionName: "Applyed", documentId: toUserId)
    }
}
