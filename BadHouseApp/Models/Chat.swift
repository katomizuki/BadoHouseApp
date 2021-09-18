import Foundation
import Firebase

struct Chat {
    var sendTime:Timestamp?
    var text:String
    var senderId:String
    var reciverId:String
}

struct ChatRoom {
    var chatRoom:String
    var user:String
    var user2:String
}
