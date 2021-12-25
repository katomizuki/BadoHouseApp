import Foundation
import FirebaseAuth
import Firebase
protocol AuthServiceProtocol {
    func register(credential: AuthCredential,
                  completion: @escaping(Result<[String: Any], Error>) -> Void)
}
struct AuthService: AuthServiceProtocol {
    func register(credential: AuthCredential, completion: @escaping (Result<[String:Any], Error>) -> Void) {
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { result, error in
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
    
    static func register(name: String?,
                         email: String?,
                         password: String?,
                         completion: @escaping (Bool, Error?) -> Void) {
        guard let email = email else { return }
        guard let name = name else { return }
        guard let password = password else { return }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("createUser Error")
                completion(false, error)
                return
            }
            print("Register Success")
            guard let uid = result?.user.uid else { return }
            UserService.setUserData(uid: uid, password: password, email: email, name: name) { result in
                completion(result, error)
            }
        }
    }
    static func loginFirebaseAuth(email: String,
                                  password: String,
                                  completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Login Error")
                completion(false, error)
                return
            }
            print("Login Success")
            completion(true, error)
        }
    }
    static func getUserId() -> String {
        guard let uid = Auth.auth().currentUser?.uid else { return ""}
        return uid
    }
}
