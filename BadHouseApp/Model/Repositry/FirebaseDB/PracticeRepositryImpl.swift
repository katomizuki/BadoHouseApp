import RxSwift

struct PracticeRepositryImpl: PracticeRepositry {
    
    func postPractice(dic: [String: Any],
                      circle: Circle,
                      user: User) -> Completable {
        
        var dictionary = dic
        dictionary["userId"] = user.uid
        dictionary["userName"] = user.name
        dictionary["circleId"] = circle.id
        dictionary["circleName"] = circle.name
        dictionary["userUrlString"] = user.profileImageUrlString
        dictionary["circleUrlString"] = circle.backGround
        let id = Ref.PracticeRef.document().documentID
        dictionary["id"] = id
        return Completable.create { observer in
            Completable.zip(postPracticeData(id: id, dic: dictionary),
                            postPracticeToMe(id: id, circle: circle, user: user))
                .subscribe {
                    observer(.completed)
                } onError: { error in
                    observer(.error(error))
                }
        }
    }
    
    func getPractices() -> Single<[Practice]> {
        FirebaseClient.shared.requestFirebaseSort(request: PracticeGetTargetType())
    }
    
    static func getPracticeById(id: String,
                                completion: @escaping(Practice) -> Void) {
        FirebaseClient.shared.getDataById(request: PracticeGetTargetType(id: id), completion: completion)
    }
    
    private func postPracticeData(id: String, dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            Ref.PracticeRef.document(id).setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    private func postPracticeToMe(id: String,
                                  circle: Circle,
                                  user: User) -> Completable {
        return Completable.create { observer in
            Ref.UsersRef.document(user.uid).collection("Practice").document(id).setData(["id": id]) { error in
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
