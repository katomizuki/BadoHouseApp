import Firebase
import RxSwift
import Domain

public struct ApplyRepositryImpl: ApplyRepositry {
    public init() { }
    private let disposeBag = DisposeBag()
    
    public func postApply(user: Domain.UserModel,
                   toUser: Domain.UserModel) -> Completable {
        return Completable.create { observer  in
            Completable.zip(sendApplyData(uid: user.uid,
                                          toUserId: toUser.uid,
                                          dic: [
                                            "toUserId": toUser.uid,
                                            "name": toUser.name,
                                            "imageUrl": toUser.profileImageUrlString,
                                            "createdAt": Timestamp(),
                                            "uid": user.uid
                                                ]),
                            sendApplyedData(uid: user.uid,
                                             toUserId: toUser.uid,
                                             dic: [
                                                "fromUserId": user.uid,
                                                "name": user.name,
                                                "imageUrl": user.profileImageUrlString,
                                                "createdAt": Timestamp(),
                                                "uid": toUser.uid
                                             ]),
                            NotificationRepositryImpl
                                .postNotification(uid: toUser.uid,
                                                  dic: ["id": user.uid,
                                                        "urlString": user.profileImageUrlString,
                                                        "notificationSelectionNumber": 0,
                                                        "titleText": user.name,
                                                        "createdAt": Timestamp()]))
                .subscribe {
                    observer(.completed)
                } onError: { error in
                    observer(.error(error))
                }
        }
    }
    
    public func notApplyFriend(uid: String,
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
    
    public func getApplyUser(user: Domain.UserModel) -> Single<[Domain.ApplyModel]> {
        FirebaseClient.shared.requestFirebaseSubData(request: UserGetApplyTargetType(id: user.uid))
    }
    
    public func getApplyedUser(user: Domain.UserModel)->Single<[Domain.ApplyedModel]> {
        FirebaseClient.shared.requestFirebaseSubData(request: UserGetApplyedTargetType(id: user.uid))
    }
    
    public func match(user: Domain.UserModel,
               friend: Domain.UserModel) -> Completable {
        UserRepositryImpl.saveFriendId(uid: user.uid)
        return Completable.create { observer in
            Completable.zip(sendUserData(id1: user.uid, id2: friend.uid, dic: ["id": friend.uid]),
                            sendUserData(id1: friend.uid, id2: user.uid, dic: ["id": user.uid]),
                            NotificationRepositryImpl.postNotification(
                                uid: user.uid,
                                dic: ["id": friend.uid,
                                      "urlString": friend.profileImageUrlString,
                                      "notificationSelectionNumber": 3,
                                      "titleText": friend.name,
                                      "createdAt": Timestamp()]),
                            NotificationRepositryImpl.postNotification(
                                uid: friend.uid,
                                dic: ["id": user.uid,
                                      "urlString": user.profileImageUrlString,
                                      "notificationSelectionNumber": 3,
                                      "titleText": user.name,
                                      "createdAt": Timestamp()]))
                .subscribe {
                    observer(.completed)
            } onError: { error in
                observer(.error(error))
            }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private func sendUserData(id1: String,
                              id2: String,
                              dic: [String: Any]) -> Completable {
        return Completable.create { observer  in
            Ref.UsersRef.document(id1).collection("Friends").document(id2).setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    private func sendApplyData(uid: String,
                               toUserId: String,
                               dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            Ref.ApplyRef.document(uid).collection("Users")
                .document(toUserId).setData(dic) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
                }
            return Disposables.create()
        }
    }
    
    private func sendApplyedData(uid: String,
                                 toUserId: String,
                                 dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            Ref.ApplyedRef.document(uid).collection("Users")
                .document(toUserId).setData(dic) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
                }
            return Disposables.create()
        }
    }
}
