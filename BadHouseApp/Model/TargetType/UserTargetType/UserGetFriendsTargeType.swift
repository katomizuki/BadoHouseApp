import FirebaseFirestore

struct UserGetFriendsTargeType: FirebaseSubCollectionTargetType {
    
    typealias Model = User
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.UsersRef }
    var subRef: CollectionReference
    var subCollectionName: String
}
