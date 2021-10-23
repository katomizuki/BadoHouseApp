import Foundation

struct ChatRoom {
    var chatRoom: String
    var user: String
    var user2: String
    init?(dic: [String: Any]) {
        guard let chatRoom = dic["chatRoomId"] as? String,
              let user = dic["user2"] as? String,
              let user2 = dic["user2"] as? String else { return nil }
        self.chatRoom = chatRoom
        self.user = user
        self.user2 = user2
    }
}
