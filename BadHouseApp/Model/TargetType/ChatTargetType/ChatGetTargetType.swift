import FirebaseFirestore

struct ChatGetTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = Chat
    
    var subId: String = ""
    var isDescending: Bool? { false }
    var sortField: String = "createdAt"
    var id: String
    var ref: CollectionReference { Ref.ChatRef }
    var subRef: CollectionReference { Ref.ChatRef }
    var subCollectionName: String { "Comment" }
}
