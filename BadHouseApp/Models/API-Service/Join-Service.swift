import Firebase
import Foundation
import RxSwift

struct JoinService {
    static func postPreJoin(user: User,
                            toUser: User, practice:Practice,
                            completion: @escaping(Result<Void, Error>) -> Void) {
        Ref.PreJoinRef.document(user.uid).collection("Users")
            .document(toUser.uid)
            .setData(["toUserId": toUser.uid,
                      "name": toUser.name,
                      "imageUrl": toUser.profileImageUrlString,
                      "createdAt": Timestamp(),
                      "uid":user.uid,
                      "practiceName":practice.title,
                      "circleImage":practice.circleUrlString]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
                Ref.PreJoinedRef.document(toUser.uid)
                    .collection("Users")
                    .document(user.uid).setData(["fromUserId": user.uid,
                                                 "name": user.name,
                                                 "imageUrl" : user.profileImageUrlString,
                                                  "createdAt": Timestamp(),
                                                  "uid": toUser.uid,
                                                 "practiceName":practice.title,
                                                 "circleImage":practice.circleUrlString]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
}
