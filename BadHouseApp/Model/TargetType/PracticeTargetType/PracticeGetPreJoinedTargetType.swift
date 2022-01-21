import FirebaseFirestore

struct PracticeGetPreJoinedTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = PreJoined
    
    var subId: String = ""
    var isDescending: Bool?
    var sortField: String = ""
    var id: String
    var ref: CollectionReference { Ref.PreJoinedRef }
    var subRef: CollectionReference { Ref.PreJoinedRef }
    var subCollectionName: String { "Users"}
}
