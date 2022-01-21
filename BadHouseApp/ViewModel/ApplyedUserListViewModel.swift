import RxSwift
import RxRelay

protocol ApplyedUserListViewModelInputs {
    func willAppear()
    func makeFriends(_ applyed: Applyed)
    func deleteFriends(_ applyed: Applyed)
}

protocol ApplyedUserListViewModelOutputs {
    var applyedRelay: BehaviorRelay<[Applyed]> { get }
    var isError: PublishSubject<Bool> { get }
    var completedFriend: PublishSubject<String> { get }
    var reload: PublishSubject<Void> { get }
    var navigationTitle: PublishSubject<String> { get }
}

protocol ApplyedUserListViewModelType {
    var inputs: ApplyedUserListViewModelInputs { get }
    var outputs: ApplyedUserListViewModelOutputs { get }
}

final class  ApplyedUserListViewModel: ApplyedUserListViewModelType, ApplyedUserListViewModelInputs, ApplyedUserListViewModelOutputs {
    
    var inputs: ApplyedUserListViewModelInputs { return self }
    var outputs: ApplyedUserListViewModelOutputs { return self }
    var applyedRelay = BehaviorRelay<[Applyed]>(value: [])
    private let disposeBag = DisposeBag()
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var completedFriend = PublishSubject<String>()
    var navigationTitle = PublishSubject<String>()
    var applyAPI: ApplyServiceProtocol
    var user: User
    
    init(applyAPI: ApplyServiceProtocol, user: User) {
        self.applyAPI = applyAPI
        self.user = user
    }
    
    func willAppear() {
        applyAPI.getApplyedUser(user: user)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] applyeds in
            self?.applyedRelay.accept(applyeds)
                self?.navigationTitle.onNext("\(applyeds.count)人から友達申請が来ています")
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func makeFriends(_ applyed: Applyed) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId,
                                    toUserId: user.uid)
        let sbj = applyedRelay.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedRelay.accept(sbj)
        reload.onNext(())
        UserService.getUserById(uid: applyed.fromUserId) { friend in
            self.applyAPI.match(user: self.user, friend: friend) { [weak self] result in
                switch result {
                case .success:
                    self?.completedFriend.onNext(applyed.name)
                    self?.saveFriendsId(id: applyed.fromUserId)
                case .failure:
                    self?.isError.onNext(true)
                }
            }
        }
    }
    
    func deleteFriends(_ applyed: Applyed) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId, toUserId: user.uid)
        let sbj = applyedRelay.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedRelay.accept(sbj)
        reload.onNext(())
    }
    
    private func saveFriendsId(id: String) {
        if UserDefaults.standard.object(forKey: "friends") != nil {
            let array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "friends")
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: "friends")
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [id], key: "friends")
        }
    }
}
