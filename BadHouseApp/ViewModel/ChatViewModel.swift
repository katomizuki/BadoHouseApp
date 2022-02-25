import Firebase
import RxSwift
import RxRelay
import ReSwift

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
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: ChatActionCreator
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    var chatsList = BehaviorRelay<[Chat]>(value: [])
    var chatId: String?
    
    init(myData: User,
         user: User,
         store: Store<AppState>,
         actionCreator: ChatActionCreator) {
        self.myData = myData
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.chatState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
    }
    
    func didLoad() {
        actionCreator.didLoad(user: user, myData: myData)
    }
    
    func sendText(_ text: String) {
        guard let chatId = chatId else { return }
        self.actionCreator.sendText(text, chatId: chatId, myData: myData, user: user)
    }
}

extension ChatViewModel: ChatViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}
extension ChatViewModel: ChatViewModelOutputs {
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}

extension ChatViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = ChatState
    
    func newState(state: ChatState) {
        chatsList.accept(state.chatsList)
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
        
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
        
        if let chatId = state.chatId {
            self.chatId = chatId
        }
    }
}
