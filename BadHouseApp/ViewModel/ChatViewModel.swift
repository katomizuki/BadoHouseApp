import Firebase
import RxSwift
import RxRelay

protocol ChatViewModelType {
    var inputs: ChatViewModelInputs { get }
    var outputs: ChatViewModelOutputs { get }
}

protocol ChatViewModelInputs {
    func didLoad()
    func sendText(_ text: String)
}

protocol ChatViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var chatsList: BehaviorRelay<[Chat]> { get }
    var reload: PublishSubject<Void> { get }
}

final class ChatViewModel: ChatViewModelInputs, ChatViewModelOutputs, ChatViewModelType {
    
    var inputs: ChatViewModelInputs { return self }
    var outputs: ChatViewModelOutputs { return self }
    let myData: User
    let user: User
    let userAPI: UserRepositry
    let chatAPI: ChatRepositry
    private let disposeBag = DisposeBag()
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var chatsList = BehaviorRelay<[Chat]>(value: [])
    var chatId: String?
    
    init(myData: User, user: User,
         userAPI: UserRepositry,
         chatAPI: ChatRepositry) {
        self.myData = myData
        self.user = user
        self.chatAPI = chatAPI
        self.userAPI = userAPI
    }
    
    private func getChat(chatId: String) {
        self.chatAPI.getChat(chatId: chatId).subscribe {[weak self] chats in
            self?.chatsList.accept(chats)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    func didLoad() {
        userAPI.judgeChatRoom(user: user, myData: myData) { isExits in
            if isExits {
                self.userAPI.getUserChatRoomById(myData: self.myData,
                                                 id: self.user.uid) { chatRoom in
                    self.chatId = chatRoom.id
                    self.getChat(chatId: chatRoom.id)
                }
            } else {
                let id = Ref.UsersRef.document(self.myData.uid).collection(R.Collection.ChatRoom).document().documentID
                self.chatId = id
                let dic: [String: Any] = ["id": id,
                                        "userId": self.user.uid,
                                        "latestTime": Timestamp(),
                                        "latestMessage": String(),
                                        "partnerName": self.user.name,
                                        "partnerUrlString": self.user.profileImageUrlString]
                let partnerDic: [String: Any] = ["id": id,
                                                "userId": self.myData.uid,
                                                "latestTime": Timestamp(),
                                                "latestMessage": String(),
                                                "partnerName": self.myData.name,
                                                "partnerUrlString": self.myData.profileImageUrlString]
                self.userAPI.postMyChatRoom(dic: dic,
                                            partnerDic: partnerDic,
                                            user: self.user,
                                            myData: self.myData,
                                            chatId: id)
            }
        }
    }
    
    func sendText(_ text: String) {
        guard let chatId = chatId else {
            return
        }
        let dic: [String: Any] = ["chatId": chatId,
                                 "text": text,
                                 "createdAt": Timestamp(),
                                 "senderId": myData.uid]
        chatAPI.postChat(chatId: chatId, dic: dic) { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.isError.onNext(true)
            }
            self.getChat(chatId: chatId)
            self.userAPI.updateChatRoom(user: self.user, myData: self.myData, message: text)
        }
    }
}
