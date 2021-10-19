import Foundation
import Firebase
struct ChatRoomService {
    static func sendChatroom(myId:String,youId:String,completion:@escaping(String)->Void) {
        let chatRoomId = Ref.ChatroomRef.document().documentID
        let chatRoomDic = ["chatRoomId":chatRoomId,"user":myId,"user2":youId]
        Ref.ChatroomRef.document(chatRoomId).setData(chatRoomDic)
        Ref.UsersRef.document(myId).collection("ChatRoom").document(chatRoomId).setData(["chatId":chatRoomId])
        Ref.UsersRef.document(youId).collection("ChatRoom").document(chatRoomId).setData(["chatId":chatRoomId])
        completion(chatRoomId)
    }
    
    static func sendDMChat(chatroomId:String,senderId:String,text:String,reciverId:String) {
        let dic = ["chatRoomId":chatroomId,"sender":senderId,"text":text,"reciver":reciverId,"sendTime":Timestamp()] as [String : Any]
        let chatId = Ref.ChatroomRef.document(chatroomId).collection("Content").document().documentID
        Ref.ChatroomRef.document(chatroomId).collection("Content").document(chatId).setData(dic)
    }
    static func sendGroupChat(teamId:String,me:User,text:String) {
        let senderId = me.uid
        let senderUrl = me.profileImageUrl
        let senderName = me.name
        let id = Ref.TeamRef.document(teamId).collection("GroupChat").document().documentID
        let dic = ["senderId":senderId,"senderUrl":senderUrl,"senderName":senderName,"chatId":id,"timeStamp":Timestamp(),"text":text] as [String : Any]
        Ref.TeamRef.document(teamId).collection("GroupChat").document(id).setData(dic)
    }
    //Mark: getChatData
    static func getChatRoomData(uid:String,completion:@escaping ([String])->Void) {
        var chatArray = [String]()
        Ref.UsersRef.document(uid).collection("ChatRoom").addSnapshotListener { snapShot, error in
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            document.forEach { element in
                let data = element.data()
                let chatId = data["chatId"] as? String ?? ""
                chatArray.append(chatId)
            }
            completion(chatArray)
        }
    }
    //Mark:LastGetChatData
    static func getChatLastData(chatId:String,completion:@escaping(Chat)-> Void){
        var textArray = [Chat]()
        Ref.ChatroomRef.document(chatId).collection("Content").order(by: "sendTime").addSnapshotListener { snapShot, error in
            textArray = []
            if let error = error {
                print(error)
                return
            }
            guard let document = snapShot?.documents else { return }
            if document.isEmpty {
                let dic = ["sendTime": nil,"text":"","sender":"","reciver":""] as [String:Any]
                let chat = Chat(dic: dic)
                textArray.append(chat)
            } else {
                document.forEach { element in
                    let data = element.data()
                    let chat = Chat(dic:data)
                    textArray.append(chat)
                }
            }
            guard let lastComment = textArray.last else { return }
            completion(lastComment)
        }
    }
}
