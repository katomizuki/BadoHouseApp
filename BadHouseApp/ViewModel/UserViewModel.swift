import RxSwift
import RxCocoa
import FirebaseAuth
import ReSwift

protocol UserViewModelInputs {
    func willAppears()
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
    private let userAPI: UserRepositry
    private let applyAPI: ApplyRepositry
    private let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let notAuthStream = PublishSubject<Void>()
    private let applyViewHiddenStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    
    init(userAPI: UserRepositry,
         applyAPI: ApplyRepositry,
         circleAPI: CircleRepositry, store: Store<AppState>) {
        self.userAPI = userAPI
        self.applyAPI = applyAPI
        self.circleAPI = circleAPI
        self.store = store
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.userState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func willAppears() {
        if let uid = Auth.auth().currentUser?.uid {
            userAPI.getUser(uid: uid).subscribe(onSuccess: {[weak self] user in
                guard let self = self else { return }
                self.userName.accept(user.name)
                self.user = user
                self.bindCircles(user: user)
                self.bindApplyedUser(user: user)
                self.bindFriends(user: user)
                if let url = URL(string: user.profileImageUrlString) {
                    self.userUrl.accept(url)
                } else {
                    self.userUrl.accept(nil)
                }
            }, onFailure: {[weak self] _ in
                guard let self = self else { return }
                self.errorInput.onNext(true)
            }).disposed(by: disposeBag)
            
            UserRepositryImpl.saveFriendId(uid: uid)
        } else {
            self.notAuthInput.onNext(())
        }
    }
    
    private func bindApplyedUser(user: User) {
        applyAPI.getApplyedUser(user: user).subscribe {[weak self] applyed in
            self?.isApplyViewHiddenInput.onNext(applyed.count == 0)
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    private func bindFriends(user: User) {
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            guard let self = self else { return }
            self.friendsRelay.accept(users)
            self.userFriendsCountText.accept("バド友　\(users.count)人")
            self.reloadInput.onNext(())
        } onFailure: {[weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    private func bindCircles(user: User) {
        userAPI.getMyCircles(uid: user.uid).subscribe { [weak self] circles in
            guard let self = self else { return }
            self.circleRelay.accept(circles)
            self.userCircleCountText.accept("所属サークル　\(circles.count)個")
            self.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
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
        guard let circle = circle else {
            return
        }
        guard let user = user else {
            return
        }
        var circles = circleRelay.value
        circles.remove(value: circle)
        circleRelay.accept(circles)
        reloadInput.onNext(())
        
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users,
                                              documentId: user.uid,
                                              subCollectionName: R.Collection.Circle,
                                              subId: circle.id)
        circleAPI.withdrawCircle(user: user,
                                 circle: circle).subscribe(onCompleted: {
            
        }, onError: { [weak self] _ in
            self?.errorInput.onNext(true)
        }).disposed(by: disposeBag)
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
        
    }
}
