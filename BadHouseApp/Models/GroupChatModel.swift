
import Firebase

struct GroupChatModel {
    var senderId: String
    var senderUrl: String
    var senderName: String
    var chatId: String
    var timeStamp: Timestamp?
    var text: String
    init?(dic: [String: Any]) {
        guard let senderId = dic["senderId"] as? String,
              let senderName = dic["senderName"] as? String,
              let senderUrl = dic["senderUrl"] as? String,
              let chatId = dic["chatId"] as? String,
              let timeStamp: Timestamp = dic["timeStamp"] as? Timestamp,
              let text = dic["text"] as? String else { return nil }
        self.senderId = senderId
        self.senderName = senderName
        self.senderUrl = senderUrl
        self.chatId = chatId
        self.timeStamp = timeStamp
        self.text = text
    }
}
