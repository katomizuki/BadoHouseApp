
import Firebase
import RxSwift
protocol UserServiceProtocol {
    func postUser(uid: String,
                  dic: [String : Any],
                  completion:@escaping (Result<Void, Error>) -> Void)
    func getUser(uid: String)->Single<User>
    func searchUser(text: String)->Single<[User]>
    func getFriends(uid: String)->Single<[User]>
    func getMyCircles(uid: String) -> Single<[Circle]>
    func getMyPractice(uid: String) -> Single<[Practice]>
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
            Ref.UsersRef.document(uid).getDocument { snapShot, error in
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
   
    func searchUser(text: String)->Single<[User]> {
        var users = [User]()
        return Single.create { singleEvent -> Disposable in
            Ref.UsersRef.getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        if let user = User(dic: $0.data()) {
                            if user.name.contains(text) && !user.isMyself {
                                users.append(user)
                            }
                        }
                    }
                    singleEvent(.success(users))
                }
            }
            return Disposables.create()
        }
    }
    static func saveFriendId(uid: String) {
        var ids = [String]()
        Ref.UsersRef.document(uid).collection("Friends").getDocuments { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snapShot = snapShot {
                snapShot.documents.forEach {
                    let dic = $0.data()
                    ids.append(dic["id"] as? String ?? "")
                }
                UserDefaultsRepositry.shared.saveToUserDefaults(element: ids, key: "friends")
            }
        }
    }
    func getFriends(uid: String) -> Single<[User]> {
        var users = [User]()
        let group = DispatchGroup()
        let blockIds:[String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "blocks")
        return Single.create { singleEvent -> Disposable in
            Ref.UsersRef.document(uid).collection("Friends").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        group.enter()
                        let uid = $0.data()["id"] as? String ?? ""
                        UserService.getUserById(uid: uid) { user in
                            defer { group.leave() }
                            if !blockIds.contains(uid) {
                            users.append(user)
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        singleEvent(.success(users))
                    }
                }
            }
            return Disposables.create()
        }
    }
    func getMyCircles(uid: String) -> Single<[Circle]> {
        var circles = [Circle]()
        let group = DispatchGroup()
        return Single.create { singleEvent -> Disposable in
            Ref.UsersRef.document(uid).collection("Circle").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        group.enter()
                        let id = $0.data()["id"] as? String ?? ""
                        CircleService.getCircle(id: id) { circle in
                            defer { group.leave() }
                            circles.append(circle)
                        }
                    }
                    group.notify(queue: .main) {
                        singleEvent(.success(circles))
                    }
                }
            }
            return Disposables.create()
        }
    }

    static func getUserById(uid: String, completion:@escaping((User) -> Void)) {
        Ref.UsersRef.document(uid).getDocument { documents, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let documents = documents {
                if let dic = documents.data() {
                    if let user = User(dic: dic) {
                    completion(user)
                    }
                }
            }
        }
    }
    func getMyPractice(uid: String) -> Single<[Practice]> {
        var practices = [Practice]()
        let group = DispatchGroup()
        return Single.create { singleEvent -> Disposable in
            Ref.UsersRef.document(uid).collection("Practice").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                if let snapShot = snapShot {
                    snapShot.documents.forEach {
                        group.enter()
                        let id = $0.data()["id"] as? String ?? ""
                        PracticeServie.getPracticeById(id: id) { practice in
                            defer { group.leave() }
                            practices.append(practice)
                        }
                    }
                    group.notify(queue: .main) {
                        singleEvent(.success(practices))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
