import FirebaseFirestore

struct UserGetCircleTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool?
    
    typealias Model = Circle
    
    var id: String
    
    var sortField: String = ""
    
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference
    
    var subCollectionName: String
    
}
