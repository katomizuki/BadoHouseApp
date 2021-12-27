import FirebaseAuth
import Firebase

protocol AuthServiceProtocol {
    func register(credential: AuthCredential,
                  completion: @escaping(Result<[String: Any], Error>) -> Void)
}
struct AuthService: AuthServiceProtocol {
    func register(credential: AuthCredential, completion: @escaping (Result<[String:Any], Error>) -> Void) {
        Auth.auth().createUser(withEmail: credential.email,
                               password: credential.password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let uid = result?.user.uid
            let dic:[String: Any] = ["uid": uid,
                                    "email":credential.email,
                                    "password": credential.password]
            completion(.success(dic))
        }
    }
}
