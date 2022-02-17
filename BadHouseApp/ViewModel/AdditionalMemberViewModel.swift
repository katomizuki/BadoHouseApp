import RxSwift
import RxRelay
import ReSwift

protocol AdditionalMemberViewModelType {
    var inputs: AdditionalMemberViewModelInputs { get }
    var outputs: AdditionalMemberViewModelOutputs { get }
}

protocol AdditionalMemberViewModelInputs {
    func invite()
    var errorInput: AnyObserver<Bool> { get }
    var completedInput: AnyObserver<Void> { get }
}

protocol AdditionalMemberViewModelOutputs {
    var friendsSubject: BehaviorRelay<[User]> { get }
    var isError: Observable<Bool> { get }
    var completed: Observable<Void> { get }
}

final class AdditionalMemberViewModel: AdditionalMemberViewModelType {
    
    var inputs: AdditionalMemberViewModelInputs { return self }
    var outputs: AdditionalMemberViewModelOutputs { return self }
    
    lazy var inviteIds = circle.member
    var friendsSubject = BehaviorRelay<[User]>(value: [])
    
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let user: User
    private let circle: Circle
    private let disposeBag = DisposeBag()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: AdditionalMemberActionCreator
    
    init(user: User,
         circle: Circle,
         store: Store<AppState>,
         actionCreator: AdditionalMemberActionCreator) {
        self.user = user
        self.circle = circle
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.additionalMember }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        self.getFriends()
    }
    
    func getFriends() {
        actionCreator.getFriends(uid: user.uid, members: self.circle.members)
    }
    
    func inviteAction(user: User?) {
        guard let user = user else { return }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    
    func invite() {
        actionCreator.invite(ids: inviteIds, circle: circle)
    }
}

extension AdditionalMemberViewModel: AdditionalMemberViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
}

extension AdditionalMemberViewModel: AdditionalMemberViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
}

extension AdditionalMemberViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = AdditionalMemberState
    
    func newState(state: AdditionalMemberState) {
        friendsSubject.accept(state.members)

        if state.completedStatus {
            completedInput.onNext(())
        }

        if state.errorStatus {
            errorInput.onNext(state.errorStatus)
        }
        
    }
}
