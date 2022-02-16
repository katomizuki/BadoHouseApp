import RxSwift
import RxCocoa
import FirebaseAuth

protocol UserViewModelInputs {
    func willAppear()
    func blockUser(_ user: User?)
    func withDrawCircle(_ circle: Circle?)
}

protocol UserViewModelOutputs {
    var userName: BehaviorRelay<String> { get }
    var userUrl: BehaviorRelay<URL?> { get }
    var userCircleCountText: BehaviorRelay<String> { get }
    var userFriendsCountText: BehaviorRelay<String> { get }
    var isError: PublishSubject<Bool> { get }
    var isApplyViewHidden: PublishSubject<Bool> { get }
    var friendsRelay: BehaviorRelay<[User]> { get }
    var reload: PublishSubject<Void> { get }
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var notAuth: PublishSubject<Void> { get }
}

protocol UserViewModelType {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}

final class UserViewModel: UserViewModelType, UserViewModelInputs, UserViewModelOutputs {
    
    var userName = BehaviorRelay<String>(value: "")
    var userFriendsCountText = BehaviorRelay<String>(value: "")
    var userCircleCountText = BehaviorRelay<String>(value: "")
    var userUrl = BehaviorRelay<URL?>(value: nil)
    var isError = PublishSubject<Bool>()
    var notAuth = PublishSubject<Void>()
    var isApplyViewHidden = PublishSubject<Bool>()
    var friendsRelay = BehaviorRelay<[User]>(value: [])
    var circleRelay = BehaviorRelay<[Circle]>(value: [])
    var reload = PublishSubject<Void>()
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
    var userAPI: UserRepositry
    var user: User?
    let applyAPI: ApplyRepositry
    let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    
    init(userAPI: UserRepositry,
         applyAPI: ApplyRepositry,
         circleAPI: CircleRepositry) {
        self.userAPI = userAPI
        self.applyAPI = applyAPI
        self.circleAPI = circleAPI
    }
    
    func willAppear() {
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
                self.isError.onNext(true)
            }).disposed(by: disposeBag)
            
            UserRepositryImpl.saveFriendId(uid: uid)
        } else {
            self.notAuth.onNext(())
        }
    }
    
    private func bindApplyedUser(user: User) {
        applyAPI.getApplyedUser(user: user).subscribe {[weak self] applyed in
            self?.isApplyViewHidden.onNext(applyed.count == 0)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    private func bindFriends(user: User) {
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            guard let self = self else { return }
            self.friendsRelay.accept(users)
            self.userFriendsCountText.accept("バド友　\(users.count)人")
            self.reload.onNext(())
        } onFailure: {[weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    private func bindCircles(user: User) {
        userAPI.getMyCircles(uid: user.uid).subscribe { [weak self] circles in
            guard let self = self else { return }
            self.circleRelay.accept(circles)
            self.userCircleCountText.accept("所属サークル　\(circles.count)個")
            self.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func blockUser(_ user: User?) {
        guard let user = user else { return }
        // ブロック処理
        saveBlockUser(user)
        var users = friendsRelay.value
        users.remove(value: user)
        friendsRelay.accept(users)
        reload.onNext(())
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
        reload.onNext(())
        
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users,
                                              documentId: user.uid,
                                              subCollectionName: R.Collection.Circle,
                                              subId: circle.id)
        circleAPI.withdrawCircle(user: user,
                                 circle: circle).subscribe(onCompleted: {
            
        }, onError: { [weak self] _ in
            self?.isError.onNext(true)
        }).disposed(by: disposeBag)
    }
}
