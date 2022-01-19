import FirebaseFirestore

struct CircleGetMembersTargetType: FirebaseSubCollectionTargetType {
    var id: String
    var ref: CollectionReference { Ref.CircleRef }
    var subRef: CollectionReference
    var subCollectionName: String
    typealias Model = User
}
