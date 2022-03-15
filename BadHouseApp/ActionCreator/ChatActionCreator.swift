//
//  ChatActionCreator.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/02/19.
//

import RxSwift
import Firebase

struct ChatActionCreator {
    private let disposeBag = DisposeBag()
    let chatAPI: any ChatRepositry
    let userAPI: any UserRepositry
    
    func sendText(_ text: String, chatId: String, myData: User, user: User) {
        let dic: [String: Any] = ["chatId": chatId,
                                 "text": text,
                                 "createdAt": Timestamp(),
                                 "senderId": myData.uid]
        
        chatAPI.postChat(chatId: chatId, dic: dic).subscribe {
            self.getChat(chatId: chatId)
            self.userAPI.updateChatRoom(user: user, myData: myData, message: text)
        } onError: { _ in
            appStore.dispatch(ChatState.ChatAction.changeErrorStatus(true))
        }.disposed(by: disposeBag)
    }
    
    private func getChat(chatId: String) {
        self.chatAPI.getChat(chatId: chatId).subscribe { chats in
            appStore.dispatch(ChatState.ChatAction.setChatList(chats))
            appStore.dispatch(ChatState.ChatAction.chageReloadStatus(true))
        } onFailure: { _ in
            appStore.dispatch(ChatState.ChatAction.changeErrorStatus(true))
        }.disposed(by: self.disposeBag)
    }
    
    func didLoad(user: User, myData: User) {
        userAPI.judgeChatRoom(user: user, myData: myData).subscribe(onSuccess: { isExits in
            if isExits {
                self.userAPI.getUserChatRoomById(myData: myData,
                                                 id: user.uid) { chatRoom in
                    self.getChat(chatId: chatRoom.id)
                    appStore.dispatch(ChatState.ChatAction.setChatId(chatRoom.id))
                }
            } else {
                let id = Ref.UsersRef.document(myData.uid)
                    .collection(R.Collection.ChatRoom).document().documentID
                
                self.userAPI.postMyChatRoom(dic: makeDic(user, id: id),
                                            partnerDic: makeDic(myData, id: id),
                                            user: user,
                                            myData: myData,
                                            chatId: id)
                appStore.dispatch(ChatState.ChatAction.setChatId(id))
            }
        }, onFailure: { _ in
            appStore.dispatch(ChatState.ChatAction.changeErrorStatus(true))
        }).disposed(by: disposeBag)
    }
    
    private func makeDic(_ user: User, id: String) -> [String: Any] {
            return ["id": id,
                    "userId": user.uid,
                    "latestTime": Timestamp(),
                    "latestMessage": String(),
                    "partnerName": user.name,
                    "partnerUrlString": user.profileImageUrlString]
    }
    
    func toggleErrorStatus() {
        appStore.dispatch(ChatState.ChatAction.changeErrorStatus(false))
    }
    
    func toggleReloadStatus() {
        appStore.dispatch(ChatState.ChatAction.chageReloadStatus(false))
    }
}
