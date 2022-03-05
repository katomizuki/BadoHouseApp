import RxSwift
import RxRelay
import ReSwift

protocol UserDetailViewModelInputs {
    func fetchChatRoom(completion: @escaping(ChatRoom) -> Void)
    func applyFriend()
    func notApplyedFriend()
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
    var completedInput: AnyObserver<Void> { get }
    var notApplyedCompletedInput: AnyObserver<Void> { get }
    var applyButtonTitleInput: AnyObserver<String> { get }
}

protocol UserDetailViewModelOutputs {
    var isError: Observable<Bool> { get }
    var friendListRelay: BehaviorRelay<[User]> { get }
    var circleListRelay: BehaviorRelay<[Circle]> { get }
    var reload: Observable<Void> { get }
    var completed: Observable<Void> { get }
    var notApplyedCompleted: Observable<Void> { get }
    var applyButtonString: Observable<String> { get }
}

protocol UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { get }
    var outputs: UserDetailViewModelOutputs { get }
}

final class UserDetailViewModel: UserDetailViewModelType {
    
    var inputs: UserDetailViewModelInputs { return self }
    var outputs: UserDetailViewModelOutputs { return self }
    
    var isApplyButtonHidden: Bool {
        return ids.contains(user.uid) || myData.uid == user.uid
    }

    var isTalkButtonHidden: Bool {
        return !(ids.contains(user.uid) && myData.uid != user.uid)
    }
    
    let friendListRelay = BehaviorRelay<[User]>(value: [])
    let circleListRelay = BehaviorRelay<[Circle]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    let user: User
    let myData: User
    let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
    
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let completedStream = PublishSubject<Void>()
    private let notApplyedCompletedStream = PublishSubject<Void>()
    private let applyButtonStream = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private var applies = [Apply]()
    private let store: Store<AppState>
    private let actionCreator: UserDetailActionCreator

    init(myData: User, user: User,
         store: Store<AppState>,
         actionCreator: UserDetailActionCreator) {
        self.user = user
        self.myData = myData
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userDetailState }
            }
            setupData()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        actionCreator.getFriends(user: user)
        actionCreator.getMyCircles(user: user)
        actionCreator.getApplyUser(myData: myData, user: user)
    }
    
    func fetchChatRoom(completion: @escaping (ChatRoom) -> Void) {
        actionCreator.fetchChatRoom(myData: myData, user: user, completion: completion)
    }
    
    func applyFriend() {
        actionCreator.applyFriend(myData: myData, user: user)
    }
    
    func notApplyedFriend() {
        actionCreator.notApplyedFriend(myData: myData, user: user)
    }
}

extension UserDetailViewModel: UserDetailViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
    
    var notApplyedCompletedInput: AnyObserver<Void> {
        notApplyedCompletedStream.asObserver()
    }
    
    var applyButtonTitleInput: AnyObserver<String> {
        applyButtonStream.asObserver()
    }
    
}
extension UserDetailViewModel: UserDetailViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
    
    var notApplyedCompleted: Observable<Void> {
        notApplyedCompletedStream.asObservable()
    }
    
    var applyButtonString: Observable<String> {
        applyButtonStream.asObservable()
    }
}
extension UserDetailViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = UserDetailState
    
    func newState(state: UserDetailState) {
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        notApplyedStateSubscribe(state)
        completedStateSubscribe(state)
        applyStateSubscribe(state)
        appliesStateSubscribe(state)
        friendStateSubscribe(state)
        circleStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: UserDetailState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func reloadStateSubscribe(_ state: UserDetailState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func notApplyedStateSubscribe(_ state: UserDetailState) {
        if state.notApplyedCompleted {
            notApplyedCompletedInput.onNext(())
            actionCreator.togglenotApplyedCompleted()
        }
    }
    
    func completedStateSubscribe(_ state: UserDetailState) {
        if state.completedStatus {
            completedInput.onNext(())
            actionCreator.toggleCompledStatus()
        }
    }
    
    func appliesStateSubscribe(_ state: UserDetailState) {
        applies = state.applies
    }
    
    func friendStateSubscribe(_ state: UserDetailState) {
        friendListRelay.accept(state.users)
    }
    
    func circleStateSubscribe(_ state: UserDetailState) {
        circleListRelay.accept(state.circles)
    }
    
    func applyStateSubscribe(_ state: UserDetailState) {
        applyButtonTitleInput.onNext(state.applyButtonTitle)
    }
}
