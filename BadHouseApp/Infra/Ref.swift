import FirebaseStorage
import FirebaseFirestore

struct Ref {
    static let UsersRef = Firestore.firestore().collection(R.Collection.Users)
    static let StorageUserImageRef =  Storage.storage().reference().child("User/Image")
    static let CircleRef = Firestore.firestore().collection("Teams")
    static let StorageTeamImageRef = Storage.storage().reference().child("Team/Image")
    static let StorageEventImageRef = Storage.storage().reference().child("Event/Image")
    static let ReportRef = Firestore.firestore().collection("Report")
    static let ApplyRef = Firestore.firestore().collection("Apply")
    static let ApplyedRef = Firestore.firestore().collection("Applyed")
    static let MatchRef = Firestore.firestore().collection("Match")
    static let PracticeRef = Firestore.firestore().collection(R.Collection.Practice)
    static let ChatRef = Firestore.firestore().collection("Chat")
    static let PreJoinRef = Firestore.firestore().collection(R.Collection.PreJoin)
    static let PreJoinedRef = Firestore.firestore().collection(R.Collection.PreJoined)
    static let JoinRef = Firestore.firestore().collection("Join")
    static let NotificationRef = Firestore.firestore().collection("Notification")
    
}

struct R {
    struct Collection {
        static let ChatRoom = "ChatRoom"
        static let Users = "Users"
        static let Practice = "Practice"
        static let PreJoined = "PreJoined"
        static let PreJoin = "PreJoin"
        static let Circle = "Circle"
    }
}
