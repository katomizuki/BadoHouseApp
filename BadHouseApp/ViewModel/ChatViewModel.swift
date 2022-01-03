//
//  ChatViewModel.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/03.
//
import Foundation
import Firebase
protocol ChatViewModelType {
    var inputs:ChatViewModelInputs { get }
    var outputs:ChatViewModelOutputs { get }
}
protocol ChatViewModelInputs {
    func didLoad()
}
protocol ChatViewModelOutputs {
    
}


final class ChatViewModel:ChatViewModelInputs, ChatViewModelOutputs, ChatViewModelType {
    var inputs: ChatViewModelInputs { return self }
    var outputs: ChatViewModelOutputs { return self }
    var myData: User
    var user: User
    var userAPI: UserServiceProtocol
    var chatAPI: ChatService
    init(myData: User,user: User,userAPI: UserServiceProtocol,chatAPI: ChatService) {
        self.myData = myData
        self.user = user
        self.chatAPI = chatAPI
        self.userAPI = userAPI
    }
    func didLoad() {
        userAPI.judgeChatRoom(user: user, myData: myData) { isExits in
            if isExits {
                // 既にチャットがある場合データを取ってくる
            } else {
                // 新しくチャットルームを作成する。
                let id = Ref.UsersRef.document(self.myData.uid).collection("ChatRoom").document().documentID
                let dic:[String:Any] = ["id":id,
                                        "userId": self.user.uid,
                                        "latestTime": Timestamp(),
                                        "latestMessage":String(),
                                        "partnerName":self.user.name,
                                        "partnerUrlString":self.user.profileImageUrlString]
                print("ss")
                self.userAPI.postMyChatRoom(dic: dic, user: self.user, myData: self.myData)
            }
        }
    }
}
