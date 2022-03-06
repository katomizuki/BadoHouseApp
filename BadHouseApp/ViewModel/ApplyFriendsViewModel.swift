import RxSwift
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
    
    let applyRelay = BehaviorRelay<[Apply]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()

    private let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: ApplyFriendsActionCreator
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: ApplyFriendsActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.applyFriendsState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupData() {
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
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        applyStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: ApplyFriendsState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func reloadStateSubscribe(_ state: ApplyFriendsState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func applyStateSubscribe(_ state: ApplyFriendsState) {
        applyRelay.accept(state.applies)
    }
}
