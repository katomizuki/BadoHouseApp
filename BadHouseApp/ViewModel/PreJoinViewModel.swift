import RxSwift
import RxRelay
import ReSwift

protocol PreJoinViewModelType {
    var inputs: PreJoinViewModelInputs { get }
    var outputs: PreJoinViewModelOutputs { get }
}

protocol PreJoinViewModelInputs {
    func delete(_ preJoin: PreJoin)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol PreJoinViewModelOutputs {
    var isError: Observable<Bool> { get }
    var preJoinList: BehaviorRelay<[PreJoin]> { get }
    var reload: Observable<Void> { get }
}

final class PreJoinViewModel: PreJoinViewModelType {
    
    var inputs: PreJoinViewModelInputs { return self }
    var outputs: PreJoinViewModelOutputs { return self }
    
    let preJoinList =  BehaviorRelay<[PreJoin]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()

    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: PrejoinActionCreator
    private let user: User

    init(user: User,
         store: Store<AppState>,
         actionCreator: PrejoinActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        self.user = user
        
        setupSubscribe()
        setupData()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.prejoinState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        actionCreator.getPreJoin(user: user)
    }
    
    func delete(_ preJoin: PreJoin) {
        actionCreator.deleteDataFromFirebase(preJoin, list: makeRemovedList(value: preJoin))
        actionCreator.delete(preJoin, list: makeRemovedList(value: preJoin))
    }
    
    private func makeRemovedList(value: PreJoin) -> [PreJoin] {
        var list = preJoinList.value
        list.remove(value: value)
        return list
    }
}

extension PreJoinViewModel: PreJoinViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}

extension PreJoinViewModel: PreJoinViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}
extension PreJoinViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = PreJoinState
    
    func newState(state: PreJoinState) {
        prejoinStateSubscribe(state)
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
    }
    
    func prejoinStateSubscribe(_ state: PreJoinState) {
        preJoinList.accept(state.preJoinList)
    }
    
    func errorStateSubscribe(_ state: PreJoinState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func reloadStateSubscribe(_ state: PreJoinState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
}
