import RxSwift
import RxRelay
import Foundation

protocol ApplyedUserListViewModelInputs {
    func willAppear()
    func makeFriends(_ applyed: Applyed)
    func deleteFriends(_ applyed: Applyed)
    var errorInput: AnyObserver<Bool> { get }
    var completedFriendInput: AnyObserver<String> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ApplyedUserListViewModelOutputs {
    var applyedRelay: BehaviorRelay<[Applyed]> { get }
    var completedFriend: Observable<String> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
    var navigationTitle: PublishSubject<String> { get }
}

protocol ApplyedUserListViewModelType {
    var inputs: ApplyedUserListViewModelInputs { get }
    var outputs: ApplyedUserListViewModelOutputs { get }
}

final class  ApplyedUserListViewModel: ApplyedUserListViewModelType {
    
    var inputs: ApplyedUserListViewModelInputs { return self }
    var outputs: ApplyedUserListViewModelOutputs { return self }
    
    var applyedRelay = BehaviorRelay<[Applyed]>(value: [])
    var navigationTitle = PublishSubject<String>()
    
    private let applyAPI: ApplyRepositry
    private let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<String>()
    private let reloadStream = PublishSubject<Void>()
    
    init(applyAPI: ApplyRepositry, user: User) {
        self.applyAPI = applyAPI
        self.user = user
    }
    
    private func saveFriendsId(id: String) {
        if UserDefaults.standard.object(forKey: R.UserDefaultsKey.friends) != nil {
            let array: [String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: R.UserDefaultsKey.friends)
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: R.UserDefaultsKey.friends)
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [id], key: R.UserDefaultsKey.friends)
        }
    }
}

extension ApplyedUserListViewModel: ApplyedUserListViewModelInputs {
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    var completedFriendInput: AnyObserver<String> {
        completedStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func willAppear() {
        applyAPI.getApplyedUser(user: user)
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] applyeds in
            self?.applyedRelay.accept(applyeds)
                self?.navigationTitle.onNext("\(applyeds.count)人から友達申請が来ています")
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func makeFriends(_ applyed: Applyed) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId,
                                    toUserId: user.uid)
        let sbj = applyedRelay.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedRelay.accept(sbj)
        reloadInput.onNext(())
        
        UserRepositryImpl.getUserById(uid: applyed.fromUserId) { friend in
            self.applyAPI.match(user: self.user,
                                friend: friend)
                .subscribe {
                    self.completedFriendInput.onNext(applyed.name)
                    self.saveFriendsId(id: applyed.fromUserId)
            } onError: { _ in
                self.errorInput.onNext(true)
            }.disposed(by: self.disposeBag)
        }
    }
    
    func deleteFriends(_ applyed: Applyed) {
        applyAPI.notApplyFriend(uid: applyed.fromUserId, toUserId: user.uid)
        let sbj = applyedRelay.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedRelay.accept(sbj)
        reloadInput.onNext(())
    }
}

extension ApplyedUserListViewModel: ApplyedUserListViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var completedFriend: Observable<String> {
        completedStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
}
