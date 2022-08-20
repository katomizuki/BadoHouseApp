import FirebaseFirestore
import RxSwift
import Domain

public struct JoinRepositryImpl: JoinRepositry {
    public init() { }
    private let disposeBag = DisposeBag()
    
    public func postPreJoin(user: Domain.UserModel, toUser: Domain.UserModel, practice: Domain.Practice) -> Completable {
        return Completable.create { observer in
                   Completable.zip(
                    postToUserData(user: user, toUser: toUser, practice: practice),
                    postUserData(user: user, toUser: toUser, practice: practice),
                    postNotification(user: user,
                                     toUser: toUser, practice: practice)
                   )
                   .subscribe(onCompleted: {
                       observer(.completed)
                   }, onError: { error in
                       observer(.error(error))
                   })
                   .disposed(by: self.disposeBag)
                   return Disposables.create()
               }
           }

    public func postUserData(user: Domain.UserModel,
                       toUser: Domain.UserModel,
                       practice: Domain.Practice) -> Completable {
        return Completable.create { observer -> Disposable in
            Ref.PreJoinRef.document(user.uid).collection("Users")
                .document(toUser.uid).setData(["toUserId": toUser.uid,
                                               "name": toUser.name,
                                               "imageUrl": toUser.profileImageUrlString,
                                               "createdAt": Timestamp(),
                                               "uid": user.uid,
                                               "practiceName": practice.title,
                                               "circleImage": practice.circleUrlString,
                                               "id": practice.id]) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
                }
            return Disposables.create()
        }
    }
    
    private func postToUserData(user: Domain.UserModel,
                                toUser: Domain.UserModel,
                                practice: Domain.Practice) -> Completable {
        return Completable.create { observer -> Disposable in
            Ref.PreJoinedRef.document(toUser.uid)
                .collection("Users")
                .document(user.uid).setData(["fromUserId": user.uid,
                                             "name": user.name,
                                             "imageUrl": user.profileImageUrlString,
                                             "createdAt": Timestamp(),
                                             "uid": toUser.uid,
                                             "practiceName": practice.title,
                                             "circleImage": practice.circleUrlString,
                                             "id": practice.id]) { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
                }
            return Disposables.create()
        }
    }
    
    private func postNotification(user: Domain.UserModel,
                                  toUser: Domain.UserModel,
                                  practice: Domain.Practice) -> Completable {
            NotificationRepositryImpl.postNotification(uid: toUser.uid,
                                                 dic: ["id": user.uid,
                                                       "urlString": user.profileImageUrlString,
                                                       "notificationSelectionNumber": 1,
                                                       "titleText": user.name,
                                                       "practiceId": practice.id,
                                                       "practiceTitle": practice.title,
                                                       "createdAt": Timestamp()])
    }
    
    public func getPrejoin(userId: String) -> Single<[Domain.PreJoin]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinTargetType(id: userId))
    }
    
    public func getPreJoined(userId: String) -> Single<[Domain.PreJoined]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinedTargetType(id: userId))
    }
    
    public func postMatchJoin(preJoined: Domain.PreJoined,
                       user: Domain.UserModel,
                       myData: Domain.UserModel) -> Completable {
        return Completable.create { observer in
            Completable.zip(postJoinFromUserData(preJoined: preJoined, user: user, myData: myData),
                            postJoinUserData(preJoined: preJoined, user: user, myData: myData),
                            NotificationRepositryImpl.postNotification(uid: user.uid,
                                                                 dic: ["id": myData.uid,
                                                                       "urlString": myData.profileImageUrlString,
                                                                       "notificationSelectionNumber": 2,
                                                                       "titleText": myData.name,
                                                                       "practiceId": preJoined.id,
                                                                       "practiceTitle": preJoined.practiceName,
                                                                       "createdAt": Timestamp()]))
                .subscribe {
                    observer(.completed)
            } onError: { error in
                observer(.error(error))
            }
        }
    }
    
    private func postJoinFromUserData(preJoined: Domain.PreJoined,
                                      user: Domain.UserModel,
                                      myData: Domain.UserModel) -> Completable {
        return Completable.create { observer  in
            Ref.UsersRef.document(preJoined.fromUserId).collection("Join").document(preJoined.id).setData(["id": preJoined.id]) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    private func postJoinUserData(preJoined: Domain.PreJoined,
                                  user: Domain.UserModel,
                                  myData: Domain.UserModel) -> Completable {
        return Completable.create { observer in
            Ref.UsersRef.document(preJoined.uid).collection("Join").document(preJoined.id).setData(["id": preJoined.id]) { error in
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
