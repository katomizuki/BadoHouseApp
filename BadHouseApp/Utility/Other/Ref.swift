import Foundation
import Firebase

struct Ref {
    static let UsersRef = Firestore.firestore().collection("Users")
    static let StorageUserImageRef =  Storage.storage().reference().child("User/Image")
    static let TeamRef = Firestore.firestore().collection("Teams")
    static let StorageTeamImageRef = Storage.storage().reference().child("Team/Image")
    static let EventRef = Firestore.firestore().collection("Event")
    static let StorageEventImageRef = Storage.storage().reference().child("Event/Image")
    static let ChatroomRef = Firestore.firestore().collection("ChatRoom")
}
