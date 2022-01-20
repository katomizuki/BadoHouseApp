import FirebaseFirestore

struct ChatRoomGetTargetType: FirebaseSubCollectionTargetType {
    var subId: String
    
    var subRef: CollectionReference { Ref.UsersRef }
    
    var subCollectionName: String { "ChatRoom" }
    
    var isDescending: Bool?
    
    var sortField: String = ""
    
    typealias Model = ChatRoom
    
    var id: String
    
    var ref: CollectionReference { Ref.UsersRef }
}
