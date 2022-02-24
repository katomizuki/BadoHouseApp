import RxSwift
import RxRelay
import ReSwift

protocol UserDetailViewModelInputs {
    func willAppears()
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
    var user: User
    var myData: User
    private let userAPI: UserRepositry
    private let applyAPI: ApplyRepositry
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let completedStream = PublishSubject<Void>()
    private let notApplyedCompletedStream = PublishSubject<Void>()
    private let applyButtonStream = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>

    let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)

    var isApplyButtonHidden: Bool {
        return ids.contains(user.uid) || myData.uid == user.uid
    }

    var isTalkButtonHidden: Bool {
        return !(ids.contains(user.uid) && myData.uid != user.uid)
    }

    init(myData: User, user: User,
         userAPI: UserRepositry,
         applyAPI: ApplyRepositry, store: Store<AppState>) {
        self.user = user
        self.myData = myData
        self.userAPI = userAPI
        self.applyAPI = applyAPI
        self.store = store
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userDetailState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func willAppears() {
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            self?.friendListRelay.accept(users)
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)

        userAPI.getMyCircles(uid: user.uid).subscribe { [weak self] circles in
            self?.circleListRelay.accept(circles)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
        
        applyAPI.getApplyUser(user: myData).subscribe { [weak self] applies in
            guard let self = self else { return }
            self.applies = applies
            if applies.filter({$0.toUserId == self.user.uid}).count != 0 {
                self.applyButtonTitleInput.onNext(R.buttonTitle.alreadyApply)
            } else {
                self.applyButtonTitleInput.onNext(R.buttonTitle.apply)
            }
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)

    }
    
    func fetchChatRoom(completion: @escaping (ChatRoom) -> Void) {
        userAPI.getUserChatRoomById(myData: myData, id: user.uid, completion: completion)
    }
    
    func applyFriend() {
        applyAPI.postApply(user: myData, toUser: user).subscribe {
            self.completedInput.onNext(())
        } onError: { _ in
            self.errorInput.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    func notApplyedFriend() {
        applyAPI.notApplyFriend(uid: myData.uid, toUserId: user.uid)
        notApplyedCompletedInput.onNext(())
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
        
    }
}
