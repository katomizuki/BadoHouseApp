import Foundation

struct ChatRoom {
    var chatRoom: String
    var user: String
    var user2: String
    init(dic: [String: Any]) {
        self.chatRoom = dic["chatRoomId"] as? String ?? ""
        self.user = dic["user"] as? String ?? ""
        self.user2 = dic["user2"] as? String ?? ""
    }
}
