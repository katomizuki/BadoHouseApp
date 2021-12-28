//
//  Apply-Service.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/28.
//

import Firebase
import RxSwift

protocol ApplyServiceProtocol {
    func getApplyUser(user: User)->Single<[Apply]>
    func getApplyedUser(user: User)->Single<[Applyed]>
    func match(uid: String,
               friendId: String,
               completion: @escaping(Result<Void, Error>) -> Void)
}
struct ApplyService:ApplyServiceProtocol {
    
    static func postApply(user: User,
                          toUser: User,
                          completion: @escaping(Result<Void, Error>) -> Void) {
        Ref.ApplyRef.document(user.uid).collection("Users")
            .document(toUser.uid)
            .setData(["toUserId": toUser.uid,
                      "name": toUser.name,
                      "imageUrl": toUser.profileImageUrlString,
                      "createdAt": Timestamp(),
                      "uid":user.uid]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
                Ref.ApplyedRef.document(toUser.uid)
                    .collection("Users")
                    .document(user.uid).setData(["fromUserId": user.uid,
                                                 "name": user.name,
                                                 "imageUrl" : user.profileImageUrlString,
                                                  "createdAt": Timestamp(),
                                                  "uid": toUser.uid]) { error in
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
        DeleteService.deleteSubCollectionData(collecionName: "Apply",
                                              documentId: uid,
                                              subCollectionName: "Users",
                                              subId: toUserId)
        DeleteService.deleteSubCollectionData(collecionName: "Applyed",
                                              documentId: toUserId,
                                              subCollectionName: "Users",
                                              subId: uid)
    }
    
    func getApplyUser(user: User) -> Single<[Apply]> {
        var applies = [Apply]()
        return Single.create { singleEvent -> Disposable in
            Ref.ApplyRef.document(user.uid).collection("Users").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        let apply = Apply(dic: $0.data())
                        applies.append(apply)
                    }
                    singleEvent(.success(applies))
                }
            }
            return Disposables.create()
        }
    }
    
    func getApplyedUser(user: User)->Single<[Applyed]> {
        var applyeds = [Applyed]()
        return Single.create { singleEvent -> Disposable in
            Ref.ApplyedRef.document(user.uid).collection("Users").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        let applyed = Applyed(dic: $0.data())
                        applyeds.append(applyed)
                    }
                    singleEvent(.success(applyeds))
                }
            }
            return Disposables.create()
        }
    }
    func match(uid: String,
               friendId: String,
               completion: @escaping(Result<Void, Error>) -> Void) {
        Ref.UsersRef.document(uid).collection("Friends").document(friendId).setData(["id": friendId]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            Ref.UsersRef.document(friendId).collection("Friends").document(uid).setData(["id": uid]) { error in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(()))
            }
        }
    }
   
}
