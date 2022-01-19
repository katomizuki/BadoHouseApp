import FirebaseFirestore

struct CircleTargetType: FirebaseTargetType {
    typealias Model = Circle
    var id: String
    var ref:CollectionReference {
        return Ref.CircleRef
    }
}
