import FirebaseFirestore

struct UserGetPracticeTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool?
    
    typealias Model = Practice
    
    var id: String
    
    var sortField: String = ""
    
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference { Ref.PracticeRef }
    
    var subCollectionName: String { "Practice" }
    
}
