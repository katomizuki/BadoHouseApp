import FirebaseAuth
import Firebase
import RxSwift

struct AuthRepositryImpl: AuthRepositry {
    
    func register(credential: AuthCredential) -> Single<[String: Any]> {
        return Single.create { observer in
            Auth.auth().createUser(withEmail: credential.email,
                                   password: credential.password) { result, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                guard let uid = result?.user.uid else { return }
                let dic: [String: Any] = ["uid": uid,
                                          "email": credential.email,
                                          "name": credential.name,
                                          "createdAt": Timestamp(),
                                          "updatedAt": Timestamp(),
                                          "password": credential.password]
                observer(.success(dic))
            }
            return Disposables.create()
        }
    }
    
    static func getUid() -> String? {
//        if let id = KeyChainRepositry.myId {
//            return id
//        } else {
            return Auth.auth().currentUser?.uid
//        }
    }
    
    static func login(email: String,
                      password: String,
                      completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email,
                           password: password,
                           completion: completion)
    }
}
