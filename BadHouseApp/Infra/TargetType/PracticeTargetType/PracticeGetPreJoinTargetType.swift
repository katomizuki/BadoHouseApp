import FirebaseFirestore
struct PracticeGetPreJoinTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = PreJoin
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var ref: CollectionReference { Ref.PreJoinRef }
    var subRef: CollectionReference { Ref.PreJoinRef }
    var sortField: String = ""
    var subCollectionName: String { "Users"}
}
