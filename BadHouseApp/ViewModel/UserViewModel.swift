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
    
    var userName = BehaviorRelay<String>(value: "")
    var userFriendsCountText = BehaviorRelay<String>(value: "")
    var userCircleCountText = BehaviorRelay<String>(value: "")
    var userUrl = BehaviorRelay<URL?>(value: nil)

    var friendsRelay = BehaviorRelay<[User]>(value: [])
    var circleRelay = BehaviorRelay<[Circle]>(value: [])

    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }

    var user: User?
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let notAuthStream = PublishSubject<Void>()
    private let applyViewHiddenStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: UserActionCreator
    
    init(store: Store<AppState>,
         actionCreator: UserActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        getUser()
    }
    
    func getUser() {
        if let uid = Auth.auth().currentUser?.uid {
            self.actionCreator.getUser(uid: uid)
        } else {
            self.notAuthInput.onNext(())
        }
    }
    
    func blockUser(_ user: User?) {
        guard let user = user else { return }
        // ブロック処理
        saveBlockUser(user)
        var users = friendsRelay.value
        users.remove(value: user)
        friendsRelay.accept(users)
        reloadInput.onNext(())
    }
    
    private func saveBlockUser(_ user: User) {
        if UserDefaults.standard.object(forKey: R.UserDefaultsKey.blocks) != nil {
            var array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.blocks)
            array.append(user.uid)
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.blocks)
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [user.uid], key: R.UserDefaultsKey.blocks)
        }
    }
    
    func withDrawCircle(_ circle: Circle?) {
        guard let circle = circle else { return }
        guard let user = user else { return }
        var circles = circleRelay.value
        circles.remove(value: circle)
        deleteCircle(user: user, circle: circle)
        actionCreator.withDrawCircle(user: user, circle: circle, circles: circles)
    }
    
    private func deleteCircle(user: User, circle: Circle) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users,
                                              documentId: user.uid,
                                              subCollectionName: R.Collection.Circle,
                                              subId: circle.id)
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
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
        
        if let user = state.user {
            userName.accept(user.name)
            self.user = user
        }
        
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
        isApplyViewHiddenInput.onNext(state.isApplyViewHidden)
        circleRelay.accept(state.circles)
        friendsRelay.accept(state.friends)
        userCircleCountText.accept(state.userCircleCountText)
        userFriendsCountText.accept(state.userFriendsCountText)
        userUrl.accept(state.userUrl)
    }
}
