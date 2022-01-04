
import Firebase
import FirebaseFirestore

struct Ref {
    static let UsersRef = Firestore.firestore().collection("Users")
    static let StorageUserImageRef =  Storage.storage().reference().child("User/Image")
    static let TeamRef = Firestore.firestore().collection("Teams")
    static let StorageTeamImageRef = Storage.storage().reference().child("Team/Image")
    static let StorageEventImageRef = Storage.storage().reference().child("Event/Image")
    static let BlockRef = Firestore.firestore().collection("Block")
    static let ApplyRef = Firestore.firestore().collection("Apply")
    static let ApplyedRef = Firestore.firestore().collection("Applyed")
    static let MatchRef = Firestore.firestore().collection("Match")
    static let PracticeRef = Firestore.firestore().collection("Practice")
    static let ChatRef = Firestore.firestore().collection("Chat")
    static let PreJoinRef = Firestore.firestore().collection("PreJoin")
    static let PreJoinedRef = Firestore.firestore().collection("PreJoined")
}
