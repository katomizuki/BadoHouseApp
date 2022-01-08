import Firebase
import Foundation
import RxSwift
protocol JoinServiceProtocol {
    func getPrejoin(userId: String)->Single<[PreJoin]>
    func getPreJoined(userId: String)->Single<[PreJoined]>
    func postMatchJoin(preJoined: PreJoined,
                       completion: @escaping(Error?)->Void)
}
struct JoinService:JoinServiceProtocol {
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
                      "practiceName": practice.title,
                      "circleImage":practice.circleUrlString,
                      "id":practice.id]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
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
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    func getPrejoin(userId: String) -> Single<[PreJoin]> {
        var prejoins = [PreJoin]()
        return Single.create { singleEvent->Disposable in
            Ref.PreJoinRef.document(userId).collection("Users").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let documents = snapShot?.documents else { return }
                documents.forEach {
                    let dic = $0.data()
                    let prejoin = PreJoin(dic: dic)
                    prejoins.append(prejoin)
                }
                singleEvent(.success(prejoins))
            }
            return Disposables.create()
        }
    }
    
    func getPreJoined(userId: String) -> Single<[PreJoined]> {
        var prejoineds = [PreJoined]()
        return Single.create { singleEvent->Disposable in
            Ref.PreJoinedRef.document(userId).collection("Users").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let documents = snapShot?.documents else { return }
                documents.forEach {
                    let dic = $0.data()
                    let prejoined = PreJoined(dic: dic)
                    prejoineds.append(prejoined)
                }
                singleEvent(.success(prejoineds))
            }
            return Disposables.create()
        }
    }
    func postMatchJoin(preJoined: PreJoined,
                       completion: @escaping(Error?)->Void) {
        Ref.UsersRef.document(preJoined.fromUserId).collection("Join").document(preJoined.id).setData(["id":preJoined.id])
        Ref.UsersRef.document(preJoined.uid).collection("Join").document(preJoined.id).setData(["id":preJoined.id],completion: completion)
    }
}
