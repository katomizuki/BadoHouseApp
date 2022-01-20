
import Firebase

struct Chat:FirebaseModel {
    var senderId: String
    var text: String
    var createdAt: Timestamp
    var chatId: String
    init(dic: [String: Any]) {
        self.senderId = dic["senderId"] as? String ?? ""
        self.text = dic["text"] as? String ?? ""
        self.chatId = dic["chatId"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    var timeString: String {
        let date = createdAt.dateValue()
        let dateString = DateUtils.stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }

}
