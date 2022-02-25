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
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: PrejoinActionCreator

    init(user: User,
         store: Store<AppState>,
         actionCreator: PrejoinActionCreator) {
        self.store = store
        self.actionCreator = actionCreator

        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.prejoinState }
            }
            self.getPreJoin(user: user)
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func getPreJoin(user: User) {
        self.actionCreator.getPreJoin(user: user)
    }
    
    func delete(_ preJoin: PreJoin) {
        var list = preJoinList.value
        list.remove(value: preJoin)
        self.actionCreator.delete(preJoin, list: list)
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
        if state.reloadStatus {
            reloadInput.onNext(())
        }
        
        if state.errorStatus {
            errorInput.onNext(true)
        }
        
        preJoinList.accept(state.preJoinList)
    }
}
