import RxRelay
import RxSwift
import ReSwift

protocol PreJoinedViewModelType {
    var inputs: PreJoinedViewModelInputs { get }
    var outputs: PreJoinedViewModelOutputs { get }
}

protocol PreJoinedViewModelInputs {
    func permission(_ preJoined: PreJoined)
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
    var preJoinedList = BehaviorRelay<[PreJoined]>(value: [])
    let user: User
    private let disposeBag = DisposeBag()
    private let reloadStream = PublishSubject<Void>()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let navigationTitleStream = PublishSubject<String>()
    private let store: Store<AppState>
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let actionCreator: PreJoinedActionCreator
    
    init(user: User, store: Store<AppState>, actionCreator: PreJoinedActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator

        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.prejoinedState }
            }
            self.getPreJoined()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func getPreJoined() {
        self.actionCreator.getPreJoined(user: user)
    }
    
    func permission(_ preJoined: PreJoined) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoin, documentId: preJoined.fromUserId, subCollectionName: R.Collection.Users, subId: preJoined.uid)
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.PreJoined, documentId: preJoined.uid, subCollectionName: R.Collection.Users, subId: preJoined.fromUserId)
        
        var list = preJoinedList.value
        list.remove(value: preJoined)
        self.actionCreator.getUser(preJoined: preJoined, user: self.user, list: list)
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
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
        
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
        
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompletedStatus()
        }
        preJoinedList.accept(state.preJoinedList)
        
        navigationTitleInput.onNext(state.navigationTitle)
        
    }
}
