import RxSwift
import RxRelay
import ReSwift
import Domain

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
    var friendsSubject: BehaviorRelay<[Domain.UserModel]> { get }
    var isError: Observable<Bool> { get }
    var completed: Observable<Void> { get }
}

final class AdditionalMemberViewModel: AdditionalMemberViewModelType {
    
    var inputs: any AdditionalMemberViewModelInputs { self }
    var outputs: any AdditionalMemberViewModelOutputs { self }

    var friendsSubject = BehaviorRelay<[Domain.UserModel]>(value: [])
    lazy var inviteIds = circle.member
    
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()

    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let user: Domain.UserModel
    private let circle: Domain.CircleModel
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: AdditionalMemberActionCreator
    
    init(user: Domain.UserModel,
         circle: Domain.CircleModel,
         store: Store<AppState>,
         actionCreator: AdditionalMemberActionCreator) {
        self.user = user
        self.circle = circle
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.additionalMember }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    // 取ってくるデータが増えてもいいようにこのように書く
    func setupData() {
        actionCreator.getFriends(uid: user.uid,
                                 members: circle.members)
    }
    
    func inviteAction(user: Domain.UserModel?) {
        guard let user = user else { return }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    private func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    
    func invite() {
        actionCreator.invite(ids: inviteIds,
                             circle: circle)
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
        completionState(state)
        friendsStateSubscribe(state)
        errorStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: AdditionalMemberState) {
        if state.errorStatus {
            errorInput.onNext(state.errorStatus)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func completionState(_ state: AdditionalMemberState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompletedStatus()
        }
    }
    
    func friendsStateSubscribe(_ state: AdditionalMemberState) {
        friendsSubject.accept(state.members)
    }
}
