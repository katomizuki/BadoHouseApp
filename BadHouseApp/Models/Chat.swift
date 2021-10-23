import Foundation
import Firebase

struct Chat {
    var sendTime: Timestamp?
    var text: String
    var senderId: String
    var reciverId: String
    init?(dic: [String: Any]) {
        guard let sendTime: Timestamp = dic["sendTime"] as? Timestamp,
              let text: String = dic["text"] as? String,
              let senderId: String = dic["sender"] as? String,
              let reciverId: String = dic["reciver"] as? String
        else { return nil }
        self.sendTime = sendTime
        self.text = text
        self.senderId = senderId
        self.reciverId = reciverId
    }
}
