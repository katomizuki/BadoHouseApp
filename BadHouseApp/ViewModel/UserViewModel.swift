import RxSwift
import RxCocoa
import FirebaseAuth
import ReSwift

protocol UserViewModelInputs {
    func blockUser(_ user: User?)
    func withDrawCircle(_ circle: Circle?)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
    var notAuthInput: AnyObserver<Void> { get }
    var isApplyViewHiddenInput: AnyObserver<Bool> { get }
}

protocol UserViewModelOutputs {
    var userName: BehaviorRelay<String> { get }
    var userUrl: BehaviorRelay<URL?> { get }
    var userCircleCountText: BehaviorRelay<String> { get }
    var userFriendsCountText: BehaviorRelay<String> { get }
    var isError: Observable<Bool> { get }
    var isApplyViewHidden: Observable<Bool> { get }
    var friendsRelay: BehaviorRelay<[User]> { get }
    var reload: Observable<Void> { get }
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var notAuth: Observable<Void> { get }
}

protocol UserViewModelType {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}

final class UserViewModel: UserViewModelType {
    
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
    
    let userName = BehaviorRelay<String>(value: "")
    let userFriendsCountText = BehaviorRelay<String>(value: "")
    let userCircleCountText = BehaviorRelay<String>(value: "")
    let userUrl = BehaviorRelay<URL?>(value: nil)
    let friendsRelay = BehaviorRelay<[User]>(value: [])
    let circleRelay = BehaviorRelay<[Circle]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    var user: User?
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let notAuthStream = PublishSubject<Void>()
    private let applyViewHiddenStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let store: Store<AppState>
    private let actionCreator: UserActionCreator
    
    init(store: Store<AppState>,
         actionCreator: UserActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        setupData()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupData() {
        if let uid = AuthRepositryImpl.getUid() {
            actionCreator.getUser(uid: uid)
            actionCreator.saveFriendId(uid: uid)
        } else {
            notAuthInput.onNext(())
        }
    }
    
    func blockUser(_ user: User?) {
        guard let user = user else { return }
        // ブロック処理
        saveBlockUser(user)
        actionCreator.setFriends(makeRemovedFriends(friendsRelay.value, user: user))
    }
    
    private func makeRemovedFriends(_ value: [User], user: User) -> [User] {
        var users = friendsRelay.value
        users.remove(value: user)
        return users
    }
    
    private func saveBlockUser(_ user: User) {
        if isExistsUserDefaults() {
            actionCreator.updateBlockIds(user: user)
        } else {
            actionCreator.saveBlocksIds(user: user)
        }
    }
    
    private func isExistsUserDefaults() -> Bool {
        return UserDefaults.standard.object(forKey: R.UserDefaultsKey.blocks) != nil
    }
    
    func withDrawCircle(_ circle: Circle?) {
        guard let circle = circle else { return }
        guard let user = user else { return }
        actionCreator.deleteCircle(user: user, circle: circle)
        actionCreator.withDrawCircle(user: user,
                                     circle: circle,
                                     circles: makeRemovedCirclesList(circle))
    }
    
    private func makeRemovedCirclesList(_ circle: Circle) -> [Circle] {
        var circles = circleRelay.value
        circles.remove(value: circle)
        return circles
    }
}

extension UserViewModel: UserViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    var notAuthInput: AnyObserver<Void> {
        notAuthStream.asObserver()
    }
    
    var isApplyViewHiddenInput: AnyObserver<Bool> {
        applyViewHiddenStream.asObserver()
    }
    
}

extension UserViewModel: UserViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isApplyViewHidden: Observable<Bool> {
        applyViewHiddenStream.asObservable()
    }
    
    var notAuth: Observable<Void> {
        notAuthStream.asObservable()
    }
}

extension UserViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = UserState
    
    func newState(state: UserState) {
        errorStateSubscriber(state)
        userStateSubscriber(state)
        reloadStateSubscriber(state)
        circleStateSubscriber(state)
        friendsStateSubscriber(state)
        userURLSubscriber(state)
        userCircleCountTextSubscriber(state)
        userFriendsCountTextSubscriber(state)
        isApplyViewHiddenSubscriber(state)
    }
    
    func errorStateSubscriber(_ state: UserState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func userStateSubscriber(_ state: UserState) {
        if let user = state.user {
            userName.accept(user.name)
            self.user = user
        }
    }
    
    func reloadStateSubscriber(_ state: UserState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func circleStateSubscriber(_ state: UserState) {
        circleRelay.accept(state.circles)
    }
    
    func friendsStateSubscriber(_ state: UserState) {
        friendsRelay.accept(state.friends)
    }
    
    func userURLSubscriber(_ state: UserState) {
        userUrl.accept(state.userUrl)
    }
    
    func userCircleCountTextSubscriber(_ state: UserState) {
        userCircleCountText.accept(state.userCircleCountText)
    }
    
    func userFriendsCountTextSubscriber(_ state: UserState) {
        userFriendsCountText.accept(state.userFriendsCountText)
    }
    
    func isApplyViewHiddenSubscriber(_ state: UserState) {
        isApplyViewHiddenInput.onNext(state.isApplyViewHidden)
    }
    
}
