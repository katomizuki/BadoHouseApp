import RxSwift
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
        var practices = [Practice]()
        return Single.create { singleEvent in
            Ref.PracticeRef.getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                snapShot?.documents.forEach({
                    let practice = Practice(dic: $0.data())
                    practices.append(practice)
                })
                singleEvent(.success(practices))
            }
            return Disposables.create()
        }
    }
}
