import RxRelay
import RxSwift
import ReSwift

protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}

protocol PreJoinedViewModelInputs {
    func onTapPermissionButton(_ preJoined: PreJoined)
    var reloadInput: AnyObserver<Void> { get }
    var completedInput: AnyObserver<Void> { get }
    var navigationTitleInput: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
}

protocol PreJoinedViewModelOutputs {
    var isError: Observable<Bool> { get }
    var preJoinedList: BehaviorRelay<[PreJoined]> { get }
    var reload: Observable<Void> { get }
    var completed: Observable<Void> { get }
    var navigationTitle: Observable<String> { get }
}

final class PreJoinedViewModel: PreJoinedViewModelType {
    
    var inputs: PreJoinedViewModelInputs { return self }
    var outputs: PreJoinedViewModelOutputs { return self }
    
    let preJoinedList = BehaviorRelay<[PreJoined]>(value: [])
    let user: User
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    private let reloadStream = PublishSubject<Void>()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let navigationTitleStream = PublishSubject<String>()
    private let store: Store<AppState>
    private let actionCreator: PreJoinedActionCreator
    
    init(user: User, store: Store<AppState>, actionCreator: PreJoinedActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator

        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.prejoinedState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        actionCreator.getPreJoined(user: user)
    }
    
    func onTapPermissionButton(_ preJoined: PreJoined) {
        actionCreator.deletePreJoinedData(preJoined)
        actionCreator.getUser(preJoined: preJoined,
                              user: user,
                              list: makePreJoinedListToSend(preJoined))
    }
    
    private func makePreJoinedListToSend(_ preJoined: PreJoined) -> [PreJoined] {
        var list = preJoinedList.value
        list.remove(value: preJoined)
        return list
    }
}

extension PreJoinedViewModel: PreJoinedViewModelInputs {
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    var navigationTitleInput: AnyObserver<String> {
        navigationTitleStream.asObserver()
    }
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
}
extension PreJoinedViewModel: PreJoinedViewModelOutputs {
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    var navigationTitle: Observable<String> {
        navigationTitleStream.asObservable()
    }
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}

extension PreJoinedViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = PreJoinedState
    
    func newState(state: PreJoinedState) {
        reloadStateSubscribe(state)
        errorStateSubscribe(state)
        completedStateSubscribe(state)
        prejoinStateSubscribe(state)
        navigationTitleStateSubscribe(state)
    }
    
    func reloadStateSubscribe(_ state: PreJoinedState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func errorStateSubscribe(_ state: PreJoinedState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func completedStateSubscribe(_ state: PreJoinedState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompletedStatus()
        }
    }
    
    func prejoinStateSubscribe(_ state: PreJoinedState) {
        preJoinedList.accept(state.preJoinedList)
    }
    
    func navigationTitleStateSubscribe(_ state: PreJoinedState) {
        navigationTitleInput.onNext(state.navigationTitle)
    }
}
