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
                  completion: @escaping (Result<Void, Error>) -> Void) {
        Ref.UsersRef.document(uid).setData(dic) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func getUser(uid: String) -> Single<User> {
        FirebaseClient.shared.requesFirebase(request: UserTargetType(id: uid))
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
                         let user = User(dic: $0.data())
                            if user.name.contains(text) && !user.isMyself {
                                users.append(user)
                            }
                    }
                    singleEvent(.success(users))
                }
            }
            return Disposables.create()
        }
    }
    static func saveFriendId(uid: String) {
        Ref.UsersRef.document(uid).collection("Friends").getDocuments { snapShot, error in
            guard let snapShot = snapShot else { return }
                let ids = snapShot.documents.map({ $0.data()["id"] as? String ?? "" })
                UserDefaultsRepositry.shared.saveToUserDefaults(element: ids, key: "friends")
        }
    }
    func getFriends(uid: String) -> Single<[User]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetFriendsTargeType(id: uid, subRef: Ref.UsersRef, subCollectionName: "Friends"))
    }
    
    func getCircles(uid: String) -> Single<[Circle]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetCircleTargetType(id: uid, subRef: Ref.CircleRef, subCollectionName: "Circle"))
    }
    func getMyCircles(uid: String) -> Single<[Circle]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetCircleTargetType(id: uid, subRef: Ref.CircleRef, subCollectionName: "Circle"))
    }

    static func getUserById(uid: String, completion: @escaping((User) -> Void)) {
        FirebaseClient.shared.getDataById(request: UserTargetType(id: uid), completion: completion)
    }
    
    func getMyPractice(uid: String) -> Single<[Practice]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetPracticeTargetType(id: uid))
    }
    
    func judgeChatRoom(user: User, myData: User, completion: @escaping(Bool) -> Void) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").whereField("userId", isEqualTo: user.uid).getDocuments { snapShot, error in
            if error != nil { completion(false) }
            guard let snapShot = snapShot else { return }
            if !snapShot.documents.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    func postMyChatRoom(dic: [String : Any],
                        partnerDic: [String : Any],
                        user: User,
                        myData: User,
                        chatId: String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).setData(dic)
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).setData(partnerDic)
        Ref.ChatRef.document(chatId).setData([:])
    }
    func getMyChatRooms(uid: String) -> Single<[ChatRoom]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: UserGetChatRoomTargetType(id: uid))
    }
    
    func getUserChatRoomById(myData: User,
                             id: String,
                             completion: @escaping(ChatRoom) -> Void) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(id).getDocument { snapShot, error in
            if error != nil { return }
            guard let dic = snapShot?.data() else { return }
            completion(ChatRoom(dic: dic))
        }
    }
    
    func updateChatRoom(user: User, myData: User, message: String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
    }
    
    func getMyJoinPractice(user: User)->Single<[Practice]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetJoinPracticeTargetType( id: user.uid))
    }
}
