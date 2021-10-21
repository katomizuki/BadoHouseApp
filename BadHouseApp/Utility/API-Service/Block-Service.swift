import Foundation
import Firebase

struct BlockService {
    // Mark sendBlock
    static func sendBlockData(userId: String, reason: String) {
        let blockId = Ref.BlockRef.document().documentID
        Ref.BlockRef.document(blockId).setData(["userId": userId,
                                                "reason": reason,
                                                "id": blockId])
    }
}
