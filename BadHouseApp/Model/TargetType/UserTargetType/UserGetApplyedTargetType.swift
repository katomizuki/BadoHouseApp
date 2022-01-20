import FirebaseFirestore

struct UserGetApplyedTargetType: FirebaseSubCollectionTargetType {
    var isDescending: Bool?
    
    var id: String
    
    var ref: CollectionReference { Ref.ApplyedRef }
    
    var subRef: CollectionReference { Ref.ApplyedRef }
    
    var subCollectionName: String { "Users" }
    
    typealias Model = Applyed
}
