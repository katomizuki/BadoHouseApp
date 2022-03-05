import RxSwift
import FirebaseAuth
import RxRelay
import ReSwift

protocol TalkViewModelInputs {
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol TalkViewModelOutputs {
    var reload: Observable<Void> { get }
    var isError: Observable<Bool> { get }
    var chatRoomList: BehaviorRelay<[ChatRoom]> { get }
}

protocol TalkViewModelType {
    var inputs: TalkViewModelInputs { get }
    var outputs: TalkViewModelOutputs { get }
}

final class TalkViewModel: TalkViewModelType {
    
    var inputs: TalkViewModelInputs { return self }
    var outputs: TalkViewModelOutputs { return self }
    
    let chatRoomList = BehaviorRelay<[ChatRoom]>(value: [])
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: TalkActionCreator
    
    init(store: Store<AppState>, actionCreator: TalkActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.talkState }
            }
            setupData()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        getChatRooms()
    }
    
    func getChatRooms() {
        guard let uid = AuthRepositryImpl.getUid() else { return }
        actionCreator.getChatRooms(uid: uid)
    }
}

extension TalkViewModel: TalkViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}
extension TalkViewModel: TalkViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}
extension TalkViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = TalkState
    
    func newState(state: TalkState) {
        errorStateSubscribe(state)
        chatRoomStateSubscribe(state)
        reloadStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: TalkState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleError()
        }
    }
    
    func reloadStateSubscribe(_ state: TalkState) {
        if state.reloadStauts {
            reloadInput.onNext(())
            actionCreator.toggleReload()
        }
    }
    
    func chatRoomStateSubscribe(_ state: TalkState) {
        chatRoomList.accept(state.talks)
    }
}
