import RxSwift

struct PracticeRepositryImpl: PracticeRepositry {
    
    func postPractice(dic: [String: Any],
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
        Ref.PracticeRef.document(id).setData(dictionary)
        
        Ref.UsersRef.document(user.uid).collection("Practice").document(id).setData(["id": id], completion: completion)
    }
    
    func getPractices() -> Single<[Practice]> {
        FirebaseClient.shared.requestFirebaseSort(request: PracticeGetTargetType())
    }
    
    static func getPracticeById(id: String,
                                completion: @escaping(Practice) -> Void) {
        FirebaseClient.shared.getDataById(request: PracticeGetTargetType(id: id), completion: completion)
    }
}
