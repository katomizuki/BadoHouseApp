
import Firebase
import RxSwift

protocol ApplyServiceProtocol {
    func getApplyUser(user: User)->Single<[Apply]>
    func getApplyedUser(user: User)->Single<[Applyed]>
    func match(user: User,
               friend: User,
               completion: @escaping(Result<Void, Error>) -> Void)
}
struct ApplyService: ApplyServiceProtocol {
    
    static func postApply(user: User,
                          toUser: User,
                          completion: @escaping(Result<Void, Error>) -> Void) {
        Ref.ApplyRef.document(user.uid).collection("Users")
            .document(toUser.uid)
            .setData(["toUserId": toUser.uid,
                      "name": toUser.name,
                      "imageUrl": toUser.profileImageUrlString,
                      "createdAt": Timestamp(),
                      "uid": user.uid]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                Ref.ApplyedRef.document(toUser.uid)
                    .collection("Users")
                    .document(user.uid).setData(["fromUserId": user.uid,
                                                 "name": user.name,
                                                 "imageUrl": user.profileImageUrlString,
                                                 "createdAt": Timestamp(),
                                                 "uid": toUser.uid]) { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        NotificationService.postNotification(uid: toUser.uid, dic: [
                            "id": user.uid,
                            "urlString": user.profileImageUrlString,
                            "notificationSelectionNumber": 0,
                            "titleText": user.name,
                            "createdAt": Timestamp()]) { error in
                                if let error = error {
                                    completion(.failure(error))
                                    return
                                }
                                completion(.success(()))
                            }
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
        FirebaseClient.shared.requestFirebaseSubData(request: UserGetApplyTargetType(id: user.uid))
//        return Single.create { singleEvent -> Disposable in
//            Ref.ApplyRef.document(user.uid).collection("Users").getDocuments { snapShot, error in
//                if let error = error {
//                    singleEvent(.failure(error))
//                    return
//                }
//                guard let snapShot = snapShot else { return }
//                let applies = snapShot.documents.map { Apply(dic: $0.data()) }
//                singleEvent(.success(applies))
//            }
//            return Disposables.create()
//        }
    }
    
    func getApplyedUser(user: User)->Single<[Applyed]> {
        FirebaseClient.shared.requestFirebaseSubData(request: UserGetApplyedTargetType(id: user.uid))
//        return Single.create { singleEvent -> Disposable in
//            Ref.ApplyedRef.document(user.uid).collection("Users").getDocuments { snapShot, error in
//                if let error = error {
//                    singleEvent(.failure(error))
//                    return
//                }
//                guard let snapShot = snapShot else { return }
//                let applyeds = snapShot.documents.map { Applyed(dic: $0.data()) }
//                singleEvent(.success(applyeds))
//            }
//            return Disposables.create()
//        }
    }
    
    func match(user: User,
               friend: User,
               completion: @escaping(Result<Void, Error>) -> Void) {
        Ref.UsersRef.document(user.uid).collection("Friends").document(friend.uid).setData(["id": friend.uid]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            Ref.UsersRef.document(friend.uid).collection("Friends").document(user.uid).setData(["id": user.uid]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            }
            NotificationService.postNotification(uid: user.uid, dic: [
                "id": friend.uid,
                "urlString": friend.profileImageUrlString,
                "notificationSelectionNumber": 3,
                "titleText": friend.name,
                "createdAt": Timestamp()]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    NotificationService.postNotification(uid: friend.uid, dic: [
                        "id": user.uid,
                        "urlString": user.profileImageUrlString,
                        "notificationSelectionNumber": 3,
                        "titleText": user.name,
                        "createdAt": Timestamp()]) { error in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            UserService.saveFriendId(uid: user.uid)
                            completion(.success(()))
                        }
                }
        }
    }
}
