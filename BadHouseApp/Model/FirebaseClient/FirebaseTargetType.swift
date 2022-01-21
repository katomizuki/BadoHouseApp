import FirebaseFirestore

protocol FirebaseTargetType {
    
    associatedtype Model: FirebaseModel
    
    var id: String { get }
    var ref: CollectionReference { get }
}
