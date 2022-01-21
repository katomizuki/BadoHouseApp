import FirebaseFirestore

struct PracticeGetTargetType: FirebaseTargetType {
    
    typealias Model = Practice
    
    var id: String = ""
    var ref: CollectionReference { Ref.PracticeRef }
}
