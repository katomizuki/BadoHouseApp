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
    
    var friendListRelay = BehaviorRelay<[User]>(value: [])
    var circleListRelay = BehaviorRelay<[Circle]>(value: [])
    private var applies = [Apply]()
    let user: User
    let myData: User
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let completedStream = PublishSubject<Void>()
    private let notApplyedCompletedStream = PublishSubject<Void>()
    private let applyButtonStream = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: UserDetailActionCreator

    let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)

    var isApplyButtonHidden: Bool {
        return ids.contains(user.uid) || myData.uid == user.uid
    }

    var isTalkButtonHidden: Bool {
        return !(ids.contains(user.uid) && myData.uid != user.uid)
    }

    init(myData: User, user: User,
         store: Store<AppState>,
         actionCreator: UserDetailActionCreator) {
        self.user = user
        self.myData = myData
        self.store = store
        self.actionCreator = actionCreator
    
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userDetailState }
            }
            self.getFriends()
            self.getApplyUser()
            self.getMyCircles()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func getFriends() {
        self.actionCreator.getFriends(user: user)
    }
    
    func getMyCircles() {
        self.actionCreator.getMyCircles(user: user)
    }
    
    func getApplyUser() {
        self.actionCreator.getApplyUser(myData: myData, user: self.user)
    }
    
    func fetchChatRoom(completion: @escaping (ChatRoom) -> Void) {
        self.actionCreator.fetchChatRoom(myData: myData, user: user, completion: completion)
    }
    
    func applyFriend() {
        self.actionCreator.applyFriend(myData: myData, user: user)
    }
    
    func notApplyedFriend() {
        self.actionCreator.notApplyedFriend(myData: myData, user: user)
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
extension UserDetailViewModel: UserDetailViewModelOutputs  {
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
        if state.errorStatus {
            errorInput.onNext(true)
        }
        
        if state.reloadStatus {
            reloadInput.onNext(())
        }
        
        if state.notApplyedCompleted {
            notApplyedCompletedInput.onNext(())
        }
        if state.completedStatus {
            completedInput.onNext(())
        }
        
        applies = state.applies
        friendListRelay.accept(state.users)
        circleListRelay.accept(state.circles)
        applyButtonTitleInput.onNext(state.applyButtonTitle)
    }
}
