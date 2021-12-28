import FirebaseAuth
import Firebase

protocol AuthServiceProtocol {
    func register(credential: AuthCredential,
                  completion: @escaping(Result<[String: Any], Error>) -> Void)
}
struct AuthService: AuthServiceProtocol {
    func register(credential: AuthCredential,
                  completion: @escaping (Result<[String : Any], Error>) -> Void) {
        Auth.auth().createUser(withEmail: credential.email,
                               password: credential.password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let uid = result?.user.uid else { return }
            let dic:[String: Any] = ["uid": uid,
                                    "email": credential.email,
                                     "name": credential.name,
                                     "createdAt": Timestamp(),
                                     "updatedAt": Timestamp(),
                                    "password": credential.password]
            completion(.success(dic))
        }
    }
    static func getUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
