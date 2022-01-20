import FirebaseFirestore

struct PracticeGetTargetType: FirebaseTargetType {
    var id: String = ""
    
    var ref: CollectionReference { Ref.PracticeRef }
    
    typealias Model = Practice
}
