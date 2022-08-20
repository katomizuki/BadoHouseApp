import FirebaseFirestore
import Domain

struct Chat: FirebaseModel {
    typealias DomainModel = Domain.ChatModel
    
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
        let dateString = stringFromDate(date: date, format: "MM月dd日HH時mm分")
        return dateString
    }
    
     private func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func convertToModel() -> ChatModel {
        return Domain.ChatModel(senderId: self.senderId,
                         text: self.text,
                         timeString: self.timeString,
                         chatId: self.chatId)
    }
    
    

}
