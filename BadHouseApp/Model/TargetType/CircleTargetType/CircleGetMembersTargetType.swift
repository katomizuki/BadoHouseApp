import FirebaseFirestore

struct CircleGetMembersTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = User
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var ref: CollectionReference { Ref.CircleRef }
    var subRef: CollectionReference
    var subCollectionName: String
    var sortField: String = ""
}
