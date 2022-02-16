import Firebase
import RxSwift

struct JoinRepositryImpl: JoinRepositry {
        
    private let disposeBag = DisposeBag()
    
    func postPreJoin(user: User, toUser: User, practice: Practice) -> Completable {
        return Completable.create { observer in
                   Completable.zip(
                    postToUserData(user: user, toUser: toUser, practice: practice),
                    postUserData(user: user, toUser: toUser, practice: practice),
                    postNotification(user: user, toUser: toUser, practice: practice)
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

     func postUserData(user: User, 
                       toUser: User,
                       practice: Practice) -> Completable {
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
    
    private func postToUserData(user: User,
                                toUser: User,
                                practice: Practice) -> Completable {
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
    
    private func postNotification(user: User,
                                  toUser: User,
                                  practice: Practice) -> Completable {
            NotificationRepositryImpl.postNotification(uid: toUser.uid,
                                                 dic: ["id": user.uid,
                                                       "urlString": user.profileImageUrlString,
                                                       "notificationSelectionNumber": 1,
                                                       "titleText": user.name,
                                                       "practiceId": practice.id,
                                                       "practiceTitle": practice.title,
                                                       "createdAt": Timestamp()])
    }
    
    func getPrejoin(userId: String) -> Single<[PreJoin]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinTargetType(id: userId))
    }
    
    func getPreJoined(userId: String) -> Single<[PreJoined]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinedTargetType(id: userId))
    }
    
    func postMatchJoin(preJoined: PreJoined,
                       user: User,
                       myData: User) -> Completable {
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
    
    private func postJoinFromUserData(preJoined: PreJoined,
                                      user: User,
                                      myData: User) -> Completable {
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
    
    private func postJoinUserData(preJoined: PreJoined,
                                  user: User,
                                  myData: User) -> Completable {
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
