
import Foundation
import Firebase

struct Ref {
    static let UsersRef = Firestore.firestore().collection("Users")
    static let StorageUserImageRef =  Storage.storage().reference().child("User/Image")
    static let TeamRef = Firestore.firestore().collection("Teams")
    static let StorageTeamImageRef = Storage.storage().reference().child("Team/Image")
    static let EventRef = Firestore.firestore().collection("Event")
}
