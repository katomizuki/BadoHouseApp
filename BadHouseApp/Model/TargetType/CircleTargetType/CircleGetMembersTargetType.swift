import FirebaseFirestore

struct CircleGetMembersTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool?
    var id: String
    var ref: CollectionReference { Ref.CircleRef }
    var subRef: CollectionReference
    var subCollectionName: String
    typealias Model = User
    var sortField: String = ""
}
