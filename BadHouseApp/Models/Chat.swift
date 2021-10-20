import Foundation
import Firebase

struct Chat {
    var sendTime:Timestamp?
    var text: String
    var senderId: String
    var reciverId: String
    init(dic: [String: Any]) {
        self.sendTime = dic["sendTime"] as? Timestamp ?? Timestamp()
        self.text = dic["text"] as? String ?? ""
        self.senderId = dic["sender"] as? String ?? ""
        self.reciverId = dic["reciver"] as? String ?? ""
    }
}
