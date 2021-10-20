import Foundation
import Firebase

struct DeleteService {
    // Mark  DeleteData
    static func deleteCollectionData(collectionName: String, documentId: String) {
        Firestore.firestore().collection(collectionName).document(documentId).delete()
    }
    // Mark DeleteChatData
    static func deleteSubCollectionData(collecionName: String, documentId: String, subCollectionName: String, subId: String) {
        Firestore.firestore().collection(collecionName).document(documentId).collection(subCollectionName).document(subId).delete()
    }
}
