import Firebase
import RxSwift
import Domain

public struct UserRepositryImpl: UserRepositry {
    public init() { }
    public func postUser(uid: String,
                  dic: [String: Any]) -> Completable {
        return Completable.create { observer in
            Ref.UsersRef.document(uid).setData(dic) { error in
                if let error = error {
                    observer(.error(error))
                    return
                }
                observer(.completed)
            }
            return Disposables.create()
        }
    }
    
    public func getUser(uid: String) -> Single<Domain.UserModel> {
        FirebaseClient.shared.requesFirebase(request: UserTargetType(id: uid))
    }
   
    public func searchUser(text: String)->Single<[Domain.UserModel]> {
        var users = [Domain.UserModel]()
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
                                users.append(user.convertToModel())
                            }
                    }
                    singleEvent(.success(users))
                }
            }
            return Disposables.create()
        }
    }
    
    public static func saveFriendId(uid: String) {
        Ref.UsersRef.document(uid).collection("Friends").getDocuments { snapShot, _ in
            guard let snapShot = snapShot else { return }
                let ids = snapShot.documents.map({ $0.data()["id"] as? String ?? "" })
                UserDefaultsRepositry.shared.saveToUserDefaults(element: ids, key: "friends")
        }
    }
    
    public func getFriends(uid: String) -> Single<[Domain.UserModel]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetFriendsTargeType(id: uid, subRef: Ref.UsersRef, subCollectionName: "Friends"))
    }
    
    public func getCircles(uid: String) -> Single<[Domain.CircleModel]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetCircleTargetType(id: uid, subRef: Ref.CircleRef, subCollectionName: "Circle"))
    }
    
    public func getMyCircles(uid: String) -> Single<[Domain.CircleModel]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetCircleTargetType(id: uid, subRef: Ref.CircleRef, subCollectionName: "Circle"))
    }

    public static func getUserById(uid: String,
                            completion: @escaping((Domain.UserModel) -> Void)) {
        FirebaseClient.shared.getDataById(request: UserTargetType(id: uid), completion: completion)
    }
    
    public func getMyPractice(uid: String) -> Single<[Domain.Practice]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetPracticeTargetType(id: uid))
    }
    
    public func judgeChatRoom(user: Domain.UserModel,
                       myData: Domain.UserModel) -> Single<Bool> {
        return Single.create { observer in
            Ref.UsersRef.document(myData.uid).collection("ChatRoom").whereField("userId", isEqualTo: user.uid).getDocuments { snapShot, error in
                if let error = error { observer(.failure(error)) }
                guard let snapShot = snapShot else { return }
                if !snapShot.documents.isEmpty {
                    observer(.success(true))
                } else {
                    observer(.success(false))
                }
            }
            return Disposables.create()
        }
    }
    
    public func postMyChatRoom(dic: [String: Any],
                        partnerDic: [String: Any],
                        user: Domain.UserModel,
                        myData: Domain.UserModel,
                        chatId: String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).setData(dic)
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).setData(partnerDic)
        Ref.ChatRef.document(chatId).setData([:])
    }
    
    public func getMyChatRooms(uid: String) -> Single<[Domain.ChatRoom]> {
        FirebaseClient.shared.requestFirebaseSortedSubData(request: UserGetChatRoomTargetType(id: uid))
    }
    
    public func getUserChatRoomById(myData: Domain.UserModel,
                             id: String,
                             completion: @escaping(Domain.ChatRoom) -> Void) {
        FirebaseClient.shared.getDataById(request: ChatRoomGetTargetType(subId: id,
                                                                         id: myData.uid), completion: completion)
    }
    
    public func updateChatRoom(user: Domain.UserModel,
                        myData: Domain.UserModel,
                        message: String) {
        Ref.UsersRef.document(myData.uid).collection("ChatRoom").document(user.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
        Ref.UsersRef.document(user.uid).collection("ChatRoom").document(myData.uid).updateData(["latestTime": Timestamp(), "latestMessage": message])
    }
    
    public func getMyJoinPractice(user: Domain.UserModel)->Single<[Domain.Practice]> {
        FirebaseClient.shared.requestFirebaseSubCollection(request: UserGetJoinPracticeTargetType( id: user.uid))
    }
}
