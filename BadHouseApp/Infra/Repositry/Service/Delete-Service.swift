import FirebaseFirestore

public struct DeleteService {
    public init() { }
    public static func deleteCollectionData(collectionName: String, documentId: String) {
        Firestore.firestore().collection(collectionName).document(documentId).delete()
    }
    
    public static func deleteSubCollectionData(collecionName: String,
                                        documentId: String,
                                        subCollectionName: String,
                                        subId: String) {
        Firestore.firestore().collection(collecionName).document(documentId).collection(subCollectionName).document(subId).delete()
    }
}
