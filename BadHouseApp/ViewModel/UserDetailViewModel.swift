import RxSwift
import RxRelay

protocol UserDetailViewModelInputs {
    func willAppear()
    func fetchChatRoom(completion: @escaping(ChatRoom) -> Void)
    func applyFriend()
    func notApplyedFriend()
}

protocol UserDetailViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var friendListRelay: BehaviorRelay<[User]> { get }
    var circleListRelay: BehaviorRelay<[Circle]> { get }
    var reload: PublishSubject<Void> { get }
    var completed: PublishSubject<Void> { get }
    var notApplyedCompleted: PublishSubject<Void> { get }
    var applyButtonString: PublishSubject<String> { get }
}

protocol UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { get }
    var outputs: UserDetailViewModelOutputs { get }
}

final class UserDetailViewModel: UserDetailViewModelType, UserDetailViewModelInputs, UserDetailViewModelOutputs {
    
    var inputs: UserDetailViewModelInputs { return self }
    var outputs: UserDetailViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var friendListRelay = BehaviorRelay<[User]>(value: [])
    var circleListRelay = BehaviorRelay<[Circle]>(value: [])
    private var applies = [Apply]()
    var reload = PublishSubject<Void>()
    var completed = PublishSubject<Void>()
    var notApplyedCompleted = PublishSubject<Void>()
    var applyButtonString = PublishSubject<String>()
    var user: User
    var myData: User
    private let userAPI: UserRepositry
    private let applyAPI: ApplyRepositry
    let ids: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
    var isApplyButtonHidden: Bool {
        return ids.contains(user.uid) || myData.uid == user.uid
    }
    var isTalkButtonHidden: Bool {
        return !(ids.contains(user.uid) && myData.uid != user.uid)
    }
    private let disposeBag = DisposeBag()
    
    init(myData: User, user: User,
         userAPI: UserRepositry,
         applyAPI: ApplyRepositry) {
        self.user = user
        self.myData = myData
        self.userAPI = userAPI
        self.applyAPI = applyAPI
    }
    
    func willAppear() {
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] users in
            self?.friendListRelay.accept(users)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)

        userAPI.getMyCircles(uid: user.uid).subscribe { [weak self] circles in
            self?.circleListRelay.accept(circles)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
        
        applyAPI.getApplyUser(user: myData).subscribe { [weak self] applies in
            guard let self = self else { return }
            self.applies = applies
            if applies.filter({$0.toUserId == self.user.uid}).count != 0 {
                self.applyButtonString.onNext(R.buttonTitle.alreadyApply)
            } else {
                self.applyButtonString.onNext(R.buttonTitle.apply)
            }
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)

    }
    
    func fetchChatRoom(completion: @escaping (ChatRoom) -> Void) {
        userAPI.getUserChatRoomById(myData: myData, id: user.uid, completion: completion)
    }
    
    func applyFriend() {
        applyAPI.postApply(user: myData, toUser: user).subscribe {
            self.completed.onNext(())
        } onError: { _ in
            self.isError.onNext(true)
        }.disposed(by: self.disposeBag)
    }
    
    func notApplyedFriend() {
        applyAPI.notApplyFriend(uid: myData.uid, toUserId: user.uid)
        notApplyedCompleted.onNext(())
    }
}
