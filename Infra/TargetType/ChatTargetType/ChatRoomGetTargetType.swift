import FirebaseFirestore
import Domain

struct ChatRoomGetTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = ChatRoom
    
    var subId: String
    var subRef: CollectionReference { Ref.UsersRef }
    var subCollectionName: String { "ChatRoom" }
    var isDescending: Bool?
    var sortField: String = ""
    var id: String
    var ref: CollectionReference { Ref.UsersRef }
}
