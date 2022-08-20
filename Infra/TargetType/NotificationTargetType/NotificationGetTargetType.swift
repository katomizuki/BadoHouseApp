import FirebaseFirestore
import Domain

struct NotificationGetTargetType: FirebaseSubCollectionTargetType {
    var subId: String = ""
    
    var isDescending: Bool? { true }
    
    var id: String
    
    var ref: CollectionReference { Ref.NotificationRef }
    
    var sortField: String = "createdAt"
    
    var subRef: CollectionReference { Ref.NotificationRef}
    
    var subCollectionName: String { "Notification" }
    
    typealias Model = Notification
}
