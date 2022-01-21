import FirebaseFirestore

struct UserGetChatRoomTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = ChatRoom
    
    var subId: String = ""
    var isDescending: Bool? { true }
    var id: String
    var ref: CollectionReference { Ref.UsersRef }
    var sortField: String = "latestTime"
    var subRef: CollectionReference { Ref.UsersRef }
    var subCollectionName: String { "ChatRoom" }
}
