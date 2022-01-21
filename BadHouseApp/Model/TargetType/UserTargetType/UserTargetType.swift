import FirebaseFirestore

struct UserTargetType: FirebaseTargetType {
    typealias Model = User
    
    var id: String
    
    var ref: CollectionReference { Ref.UsersRef }
}
