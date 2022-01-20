import FirebaseFirestore

struct UserGetJoinPracticeTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    typealias Model = Practice
    
    var isDescending: Bool?
    
    var id: String
    
    var sortField: String = ""
    
    var ref: CollectionReference { Ref.UsersRef }
    
    var subRef: CollectionReference { Ref.PracticeRef }
    
    var subCollectionName: String { "Join" }
    
}
