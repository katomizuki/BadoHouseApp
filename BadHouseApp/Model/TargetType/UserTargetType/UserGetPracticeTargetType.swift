import FirebaseFirestore

struct UserGetPracticeTargetType: FirebaseSubCollectionTargetType {
    
    typealias Model = Practice
    
    var subId: String = ""
    var isDescending: Bool?
    var id: String
    var sortField: String = ""
    var ref: CollectionReference { Ref.UsersRef }
    var subRef: CollectionReference { Ref.PracticeRef }
    var subCollectionName: String { "Practice" }
}
