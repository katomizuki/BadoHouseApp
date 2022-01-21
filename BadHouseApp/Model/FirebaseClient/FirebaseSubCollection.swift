import FirebaseFirestore

protocol FirebaseSubCollectionTargetType {
    
    associatedtype Model: FirebaseModel
    
    var id: String { get }
    var ref: CollectionReference { get }
    var subRef: CollectionReference { get }
    var subCollectionName: String { get }
    var isDescending: Bool? { get }
    var sortField: String { get }
    var subId: String { get }
}
