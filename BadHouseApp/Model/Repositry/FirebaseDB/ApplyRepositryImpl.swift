import Firebase
import RxSwift

struct ApplyRepositryImpl: ApplyRepositry {
    
    func postApply(user: User,
                   toUser: User,
                   completion: @escaping(Result<Void, Error>) -> Void) {
        sendApplyData(uid: user.uid, toUserId: toUser.uid, dic: ["toUserId": toUser.uid,
                                                                 "name": toUser.name,
                                                                 "imageUrl": toUser.profileImageUrlString,
                                                                 "createdAt": Timestamp(),
                                                                 "uid": user.uid])
        sendApplyedData(uid: user.uid, toUserId: toUser.uid, dic: ["fromUserId": user.uid,
                                                                   "name": user.name,
                                                                   "imageUrl": user.profileImageUrlString,
                                                                   "createdAt": Timestamp(),
                                                                   "uid": toUser.uid])
        NotificationRepositryImpl.postNotification(uid: toUser.uid, dic: [
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
    
    func notApplyFriend(uid: String,
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
    }
    
    func getApplyedUser(user: User)->Single<[Applyed]> {
        FirebaseClient.shared.requestFirebaseSubData(request: UserGetApplyedTargetType(id: user.uid))
    }
    
    func match(user: User,
               friend: User,
               completion: @escaping(Result<Void, Error>) -> Void) {
        
        sendUserData(id1: user.uid, id2: friend.uid, dic: ["id": friend.uid])
        
        sendUserData(id1: friend.uid, id2: user.uid, dic: ["id": user.uid])
        
        NotificationRepositryImpl.postNotification(uid: user.uid,
                                             dic: ["id": friend.uid,
                                                   "urlString": friend.profileImageUrlString,
                                                   "notificationSelectionNumber": 3,
                                                   "titleText": friend.name,
                                                   "createdAt": Timestamp()]) { error in
                                                        if let error = error {
                                                            completion(.failure(error))
                                                            return
                                                        }
            
            NotificationRepositryImpl.postNotification(uid: friend.uid,
                                                 dic: ["id": user.uid,
                                                       "urlString": user.profileImageUrlString,
                                                       "notificationSelectionNumber": 3,
                                                       "titleText": user.name,
                                                       "createdAt": Timestamp()]) { error in
                                                            if let error = error {
                                                                completion(.failure(error))
                                                                return
                                                            }
                UserRepositryImpl.saveFriendId(uid: user.uid)
                completion(.success(()))
            }
        }
    }
    
    private func sendUserData(id1: String, id2: String, dic: [String: Any]) {
        Ref.UsersRef.document(id1).collection("Friends").document(id2).setData(dic)
    }
    
    private func sendApplyData(uid: String, toUserId: String, dic: [String: Any]) {
        Ref.ApplyRef.document(uid).collection("Users")
            .document(toUserId).setData(dic)
    }
    
    private func sendApplyedData(uid: String, toUserId: String, dic: [String: Any]) {
        Ref.ApplyedRef.document(uid).collection("Users")
            .document(toUserId).setData(dic)
    }
}
