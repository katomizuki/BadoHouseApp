import FirebaseFirestore

struct UserGetCircleTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = Circle
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.UsersRef }
    var subRef: CollectionReference
    var subCollectionName: String
}
