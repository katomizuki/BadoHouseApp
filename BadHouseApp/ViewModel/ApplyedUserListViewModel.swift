import RxSwift
import RxRelay
import Foundation
protocol ApplyedUserListViewModelInputs {
    func willAppear()
    func makeFriends(_ applyed: Applyed)
    func deleteFriends(_ applyed: Applyed)
}
protocol ApplyedUserListViewModelOutputs {
    var applyedSubject: BehaviorRelay<[Applyed]> { get }
    var isError: PublishSubject<Bool> { get }
    var completedFriend:PublishSubject<String> { get }
    var reload: PublishSubject<Void> { get }
}
protocol ApplyedUserListViewModelType {
    var inputs: ApplyedUserListViewModelInputs { get }
    var outputs: ApplyedUserListViewModelOutputs { get }
}
final class  ApplyedUserListViewModel: ApplyedUserListViewModelType, ApplyedUserListViewModelInputs,ApplyedUserListViewModelOutputs {
    
    var inputs: ApplyedUserListViewModelInputs { return self }
    var outputs: ApplyedUserListViewModelOutputs { return self }
    var applyedSubject = BehaviorRelay<[Applyed]>(value: [])
    private let disposeBag = DisposeBag()
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var completedFriend = PublishSubject<String>()
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
            self?.applyedSubject.accept(applyeds)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func makeFriends(_ applyed: Applyed) {
        ApplyService.notApplyFriend(uid: applyed.fromUserId,
                                    toUserId: user.uid)
        let sbj = applyedSubject.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedSubject.accept(sbj)
        reload.onNext(())
        print(user.uid,applyed.fromUserId)
        applyAPI.match(uid: user.uid, friendId: applyed.fromUserId) { [weak self] result in
            switch result {
            case .success:
                self?.completedFriend.onNext(applyed.name)
                self?.saveFriendsId(id: applyed.fromUserId)
            case .failure:
                self?.isError.onNext(true)
            }
        }
    }
    
    func deleteFriends(_ applyed: Applyed) {
        ApplyService.notApplyFriend(uid: applyed.fromUserId, toUserId: user.uid)
        let sbj = applyedSubject.value.filter {
            $0.fromUserId != applyed.fromUserId
        }
        applyedSubject.accept(sbj)
        reload.onNext(())
    }
    private func saveFriendsId(id:String) {
        if UserDefaults.standard.object(forKey: "friends") != nil {
            var array:[String] = UserDefaultsRepositry.shared.loadFromUserDefaults(key: "friends")
            UserDefaultsRepositry.shared.saveToUserDefaults(element: array, key: "friends")
        } else {
            UserDefaultsRepositry.shared.saveToUserDefaults(element: [id], key: "friends")
        }
    }
}
