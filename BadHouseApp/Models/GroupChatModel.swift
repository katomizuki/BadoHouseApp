import Foundation
import Firebase

struct GroupChatModel {
    var senderId:String
    var senderUrl:String
    var senderName:String
    var chatId:String
    var timeStamp:Timestamp?
    var text:String
    
    init(dic:[String:Any]) {
        self.senderId = dic["senderId"] as? String ?? ""
        self.senderName = dic["senderName"] as? String ?? ""
        self.senderUrl = dic["senderUrl"] as? String ?? ""
        self.chatId = dic["chatId"] as? String ?? ""
        self.timeStamp = dic["timeStamp"] as? Timestamp ?? Timestamp()
        self.text = dic["text"] as? String ?? ""
    }
}


