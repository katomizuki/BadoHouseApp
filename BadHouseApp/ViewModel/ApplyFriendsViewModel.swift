import RxSwift
import FirebaseAuth
import RxRelay
import ReSwift

protocol ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { get }
    var outputs: ApplyFriendsViewModelOutputs { get }
}

protocol ApplyFriendsViewModelInputs {
    func onTrashButton(apply: Apply)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ApplyFriendsViewModelOutputs {
    var applyRelay: BehaviorRelay<[Apply]> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

final class ApplyFriendsViewModel: ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { return self }
    var outputs: ApplyFriendsViewModelOutputs { return self }
    
    var applyRelay = BehaviorRelay<[Apply]>(value: [])
    private let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: ApplyFriendsActionCreator
    
    init(user: User, store: Store<AppState>, actionCreator: ApplyFriendsActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.applyFriendsState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        actionCreator.getApplyData(user)
    }
    
}

extension ApplyFriendsViewModel: ApplyFriendsViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func onTrashButton(apply: Apply) {
        actionCreator.onTrashButton(apply: apply, uid: self.user.uid, list: applyRelay.value)
    }
}

extension  ApplyFriendsViewModel: ApplyFriendsViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}

extension ApplyFriendsViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = ApplyFriendsState
    
    func newState(state: ApplyFriendsState) {
        applyRelay.accept(state.applies)

        if state.reloadStatus {
            reloadInput.onNext(())
        }

        if state.errorStatus {
            errorInput.onNext(true)
        }
        
    }
}
