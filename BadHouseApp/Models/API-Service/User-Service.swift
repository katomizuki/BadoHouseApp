
import Firebase
import RxSwift
protocol UserServiceProtocol {
    func postUser(uid: String,
                  dic: [String : Any],
                  completion:@escaping (Result<Void, Error>) -> Void)
    func getUser(uid: String)->Single<User>
}
struct UserService: UserServiceProtocol {
    func postUser(uid: String,
                  dic: [String : Any],
                  completion:@escaping (Result<Void, Error>) -> Void) {
        Ref.UsersRef.document(uid).setData(dic) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func getUser(uid: String) -> Single<User> {
        return Single.create { singleEvent -> Disposable in
            Ref.UsersRef.document(uid).getDocument() { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    guard let dic = snapShot.data() else { return }
                    let user = User(dic: dic)
                    if let user = user {
                        singleEvent(.success(user))
                    }
                }
            }
            return Disposables.create()
        }
    }
    static func getUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
}

