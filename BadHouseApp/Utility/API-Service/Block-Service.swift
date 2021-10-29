import Foundation
import Firebase

struct BlockService {
    // MARK: - sendBlockData
    static func sendBlockData(userId: String, reason: String) {
        let blockId = Ref.BlockRef.document().documentID
        Ref.BlockRef.document(blockId).setData(["userId": userId,
                                                "reason": reason,
                                                "id": blockId])
    }
    static func sendBlockEventData(eventId: String,completion:@escaping (Result<String, Error?>) -> Void) {
        let blockId = Ref.BlockRef.document().documentID
        Ref.BlockRef.document(blockId).setData(["eventId": eventId,
                                                "id": blockId]) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(FirebaseError.netError))
                return
            }
            completion(.success("Success"))
        }
    }
}
