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
//any 型としてのプロトコル 制約としてのプロトコル some
final class ChatViewModel: ChatViewModelType {
    
    var inputs: any ChatViewModelInputs { self }
    var outputs: any ChatViewModelOutputs { self }
    
    var chatId: String?
    
    let myData: User
    let user: User
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let chatsList = BehaviorRelay<[Chat]>(value: [])
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: ChatActionCreator
    
    init(myData: User,
         user: User,
         store: Store<AppState>,
         actionCreator: ChatActionCreator) {
        self.myData = myData
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
    }
    
    func didLoad() {
        actionCreator.didLoad(user: user, myData: myData)
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.chatState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func sendText(_ text: String) {
        guard let chatId = chatId else { return }
        actionCreator.sendText(text, chatId: chatId, myData: myData, user: user)
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
        chatListSubscribe(state)
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        chatIdSubscribe(state)
    }
    
    func reloadStateSubscribe(_ state: ChatState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func errorStateSubscribe(_ state: ChatState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func chatListSubscribe(_ state: ChatState) {
        chatsList.accept(state.chatsList)
    }
    
    func chatIdSubscribe(_ state: ChatState) {
        if let chatId = state.chatId {
            self.chatId = chatId
        }
    }
}
