import RxRelay
import RxSwift
import ReSwift

protocol BlockListViewModelType {
    var inputs: BlockListViewModelInputs { get }
    var outputs: BlockListViewModelOutputs { get }
}

protocol BlockListViewModelInputs {
    func removeBlock(_ user: User)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol BlockListViewModelOutputs {
    var blockListRelay: BehaviorRelay<[User]> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

final class BlockListViewModel: BlockListViewModelType {
    
    var inputs: any BlockListViewModelInputs { self }
    var outputs: any BlockListViewModelOutputs { self }
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let blockListRelay = BehaviorRelay<[User]>(value: [])

    private let store: Store<AppState>
    private let disposeBag = DisposeBag()
    private let actionCreator: BlockListActionCreator
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private var blockIds: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.blocks)

    init(store: Store<AppState>,
         actionCreator: BlockListActionCreator) {
        self.store = store
        self.actionCreator = actionCreator

        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.blockListState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func setupData() {
        actionCreator.getBlockList(blockIds)
    }
}

extension BlockListViewModel: BlockListViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func removeBlock(_ user: User) {
        actionCreator.removeBlock(user, ids: self.blockIds, blockList: blockListRelay.value)
    }
}

extension BlockListViewModel: BlockListViewModelOutputs {
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}

extension BlockListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = BlockListState
    
    func newState(state: BlockListState) {
       reloadStateSubscribe(state)
       blockListStateSubscribe(state)
    }

    func blockListStateSubscribe(_ state: BlockListState) {
        blockListRelay.accept(state.users)
    }
    
    func reloadStateSubscribe(_ state: BlockListState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
}
