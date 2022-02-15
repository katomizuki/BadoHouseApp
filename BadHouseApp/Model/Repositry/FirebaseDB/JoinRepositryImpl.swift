import Firebase
import RxSwift

struct JoinRepositryImpl: JoinRepositry {
    
    func postPreJoin(user: User,
                     toUser: User, practice: Practice,
                     completion: @escaping(Result<Void, Error>) -> Void) {
        
        Ref.PreJoinRef.document(user.uid).collection("Users")
            .document(toUser.uid).setData(["toUserId": toUser.uid,
                                           "name": toUser.name,
                                           "imageUrl": toUser.profileImageUrlString,
                                           "createdAt": Timestamp(),
                                           "uid": user.uid,
                                           "practiceName": practice.title,
                                           "circleImage": practice.circleUrlString,
                                           "id": practice.id])
        
        Ref.PreJoinedRef.document(toUser.uid)
            .collection("Users")
            .document(user.uid).setData(["fromUserId": user.uid,
                                         "name": user.name,
                                         "imageUrl": user.profileImageUrlString,
                                         "createdAt": Timestamp(),
                                         "uid": toUser.uid,
                                         "practiceName": practice.title,
                                         "circleImage": practice.circleUrlString,
                                         "id": practice.id])
        
        NotificationRepositryImpl.postNotification(uid: toUser.uid,
                                             dic: ["id": user.uid,
                                                   "urlString": user.profileImageUrlString,
                                                   "notificationSelectionNumber": 1,
                                                   "titleText": user.name,
                                                   "practiceId": practice.id,
                                                   "practiceTitle": practice.title,
                                                   "createdAt": Timestamp()]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func getPrejoin(userId: String) -> Single<[PreJoin]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinTargetType(id: userId))
    }
    
    func getPreJoined(userId: String) -> Single<[PreJoined]> {
        FirebaseClient.shared.requestFirebaseSubData(request: PracticeGetPreJoinedTargetType(id: userId))
    }
    
    func postMatchJoin(preJoined: PreJoined,
                       user: User,
                       myData: User,
                       completion: @escaping(Error?) -> Void) {
        
        Ref.UsersRef.document(preJoined.fromUserId).collection("Join").document(preJoined.id).setData(["id": preJoined.id])
        
        Ref.UsersRef.document(preJoined.uid).collection("Join").document(preJoined.id).setData(["id": preJoined.id])
        
        NotificationRepositryImpl.postNotification(uid: user.uid,
                                             dic: ["id": myData.uid,
                                                   "urlString": myData.profileImageUrlString,
                                                   "notificationSelectionNumber": 2,
                                                   "titleText": myData.name,
                                                   "practiceId": preJoined.id,
                                                   "practiceTitle": preJoined.practiceName,
                                                   "createdAt": Timestamp()], completion: completion)
    }
}
