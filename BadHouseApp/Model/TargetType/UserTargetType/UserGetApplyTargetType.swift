import FirebaseFirestore

struct UserGetApplyTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = Apply
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.ApplyRef }
    var subRef: CollectionReference { Ref.ApplyRef }
    var subCollectionName: String { "Users" }
}
