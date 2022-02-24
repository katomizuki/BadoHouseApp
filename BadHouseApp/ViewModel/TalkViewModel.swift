import RxSwift
import FirebaseAuth
import RxRelay
import ReSwift

protocol TalkViewModelInputs {
    func willAppears()
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
    private let userAPI: UserRepositry
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    
    init(userAPI: UserRepositry, store: Store<AppState>) {
        self.userAPI = userAPI
        self.store = store
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.talkState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func willAppears() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        userAPI.getMyChatRooms(uid: uid).subscribe { [weak self] chatRooms in
            self?.chatRoomList.accept(chatRooms)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
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
        
    }
}
