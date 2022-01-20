import RxSwift
import Foundation
protocol PracticeServieProtocol {
    func getPractices()->Single<[Practice]>
}
struct PracticeServie: PracticeServieProtocol {
    static func postPractice(dic:[String:Any],
                             circle: Circle,
                             user: User,
                             completion: @escaping(Error?) -> Void) {
        var dictionary = dic
        dictionary["userId"] = user.uid
        dictionary["userName"] = user.name
        dictionary["circleId"] = circle.id
        dictionary["circleName"] = circle.name
        dictionary["userUrlString"] = user.profileImageUrlString
        dictionary["circleUrlString"] = circle.backGround
        let id = Ref.PracticeRef.document().documentID
        dictionary["id"] = id
        Ref.PracticeRef.document(id).setData(dictionary, completion: completion)
        Ref.UsersRef.document(user.uid).collection("Practice").document(id).setData(["id":id])
    }
    func getPractices() -> Single<[Practice]> {
        FirebaseClient.shared.requestFirebaseSort(request: PracticeGetTargetType())
//        return Single.create { singleEvent in
//            Ref.PracticeRef.getDocuments { snapShot, error in
//                if let error = error {
//                    singleEvent(.failure(error))
//                    return
//                }
//                guard let snapShot = snapShot else { return }
//                let practices = snapShot.documents.map { Practice(dic: $0.data()) }
//                singleEvent(.success(practices))
//            }
//            return Disposables.create()
//        }
    }
    static func getPracticeById(id: String,
                                completion: @escaping(Practice) -> Void) {
        Ref.PracticeRef.document(id).getDocument { snapShot, error in
            if error != nil {
                return
            }
            if let dic = snapShot?.data() {
                let practice = Practice(dic: dic)
                completion(practice)
            }
        }
    }
    
}
