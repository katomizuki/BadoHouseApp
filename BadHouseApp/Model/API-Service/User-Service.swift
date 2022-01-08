import Firebase
import RxSwift
import UIKit

protocol UserServiceProtocol {
    func postUser(uid: String,
                  dic: [String :Any],
                  completion: @escaping (Result<Void, Error>) -> Void)
    func getUser(uid: String)->Single<User>
    func searchUser(text: String)->Single<[User]>
    func getFriends(uid: String)->Single<[User]>
    func getMyCircles(uid: String) -> Single<[Circle]>
    func getMyPractice(uid: String) -> Single<[Practice]>
    func judgeChatRoom(user: User, myData: User, completion: @escaping (Bool) -> Void)
    func postMyChatRoom(dic: [String: Any],
                        partnerDic: [String: Any],
                        user: User,
                        myData: User,
                        chatId: String)
    func getMyChatRooms(uid: String)-> Single<[ChatRoom]>
    func getUserChatRoomById(myData: User,
                             id: String,
                             completion: @escaping(ChatRoom) -> Void)
    func updateChatRoom(user: User, myData: User,message: String)
    func getMyJoinPractice(user:User)->Single<[Practice]>
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
        let blockIds: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "blocks")
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
    
    func judgeChatRoom(user: User, myData: User, completion: @escaping(Bool) -> Void) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").whereField("userId", isEqualTo: user.uid).getDocuments { snapShot, error in
            if error != nil {
                completion(false)
            }
            guard let snapShot = snapShot else { return }
            if !snapShot.documents.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    func postMyChatRoom(dic: [String : Any], partnerDic: [String:Any], user: User, myData: User, chatId:String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).setData(dic)
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).setData(partnerDic)
        Ref.ChatRef.document(chatId).setData([:])
    }
    func getMyChatRooms(uid: String) -> Single<[ChatRoom]> {
        var chatRooms = [ChatRoom]()
        return Single.create { singleEvent->Disposable in
            Ref.UsersRef.document(uid).collection("ChatRoom").order(by: "latestTime", descending: true).getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                snapShot.documents.forEach {
                    let dic = $0.data()
                    let chatRoom = ChatRoom(dic: dic)
                    chatRooms.append(chatRoom)
                }
                singleEvent(.success(chatRooms))
            }
            return Disposables.create()
        }
    }
    
    func getUserChatRoomById(myData: User,
                             id: String,
                             completion: @escaping(ChatRoom)->Void) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(id).getDocument { snapShot, error in
            if error != nil {
                return
            }
            guard let dic = snapShot?.data() else { return }
            let chatRoom = ChatRoom(dic: dic)
            completion(chatRoom)
        }
    }
    
    func updateChatRoom(user:User,myData:User,message:String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
    }
    func getMyJoinPractice(user:User)->Single<[Practice]> {
        var practices = [Practice]()
        let group = DispatchGroup()
        return Single.create { singleEvent->Disposable in
            Ref.UsersRef.document(user.uid).collection("Join").getDocuments { snapShot, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }
                guard let snapShot = snapShot else { return }
                snapShot.documents.forEach {
                    group.enter()
                    let dic = $0.data()
                    let id = dic["id"] as? String ?? ""
                    PracticeServie.getPracticeById(id: id) { practice in
                        defer { group.leave() }
                        practices.append(practice)
                    }
                }
                group.notify(queue: .main) {
                    singleEvent(.success(practices))
                }
            }
            return Disposables.create()
        }
    }
}
