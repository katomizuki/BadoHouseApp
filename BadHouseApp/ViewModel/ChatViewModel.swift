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
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ChatViewModelOutputs {
    var chatsList: BehaviorRelay<[Chat]> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

final class ChatViewModel: ChatViewModelType {
    
    var inputs: ChatViewModelInputs { return self }
    var outputs: ChatViewModelOutputs { return self }
    
    let myData: User
    let user: User
    private let userAPI: UserRepositry
    private let chatAPI: ChatRepositry
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
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
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    func didLoad() {
        userAPI.judgeChatRoom(user: user, myData: myData).subscribe(onSuccess: { isExits in
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
        }, onFailure: { _ in
            self.errorInput.onNext(true)
        }).disposed(by: disposeBag)
    }
    
    func sendText(_ text: String) {
        guard let chatId = chatId else {
            return
        }
        let dic: [String: Any] = ["chatId": chatId,
                                 "text": text,
                                 "createdAt": Timestamp(),
                                 "senderId": myData.uid]
        
        chatAPI.postChat(chatId: chatId, dic: dic).subscribe {
            self.getChat(chatId: chatId)
            self.userAPI.updateChatRoom(user: self.user, myData: self.myData, message: text)
        } onError: { _ in
            self.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
}

extension ChatViewModel : ChatViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}
extension ChatViewModel : ChatViewModelOutputs {
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}
