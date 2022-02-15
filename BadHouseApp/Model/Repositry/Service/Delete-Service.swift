import FirebaseFirestore

struct DeleteService {
    
    static func deleteCollectionData(collectionName: String, documentId: String) {
        Firestore.firestore().collection(collectionName).document(documentId).delete()
    }
    
    static func deleteSubCollectionData(collecionName: String,
                                        documentId: String,
                                        subCollectionName: String,
                                        subId: String) {
        Firestore.firestore().collection(collecionName).document(documentId).collection(subCollectionName).document(subId).delete()
    }
}
