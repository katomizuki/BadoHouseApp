import RxSwift
import FirebaseAuth
import RxRelay

protocol ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { get }
    var outputs: ApplyFriendsViewModelOutputs { get }
}

protocol ApplyFriendsViewModelInputs {
    func onTrashButton(apply: Apply)
}

protocol ApplyFriendsViewModelOutputs {
    var applyRelay: BehaviorRelay<[Apply]> { get }
    var isError: PublishSubject<Bool> { get }
    var reload: PublishSubject<Void> { get }
}

final class ApplyFriendsViewModel: ApplyFriendsViewModelInputs, ApplyFriendsViewModelOutputs, ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { return self }
    var outputs: ApplyFriendsViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var applyRelay = BehaviorRelay<[Apply]>(value: [])
    var reload = PublishSubject<Void>()
    private let user: User
    private let applyAPI: ApplyRepositry
    private let disposeBag = DisposeBag()
    
    init(user: User, applyAPI: ApplyRepositry) {
        self.user = user
        self.applyAPI = applyAPI
        applyAPI.getApplyUser(user: user).subscribe {[weak self] apply in
            self?.applyRelay.accept(apply)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func onTrashButton(apply: Apply) {
        applyAPI.notApplyFriend(uid: self.user.uid, toUserId: apply.toUserId)
        let value = applyRelay.value.filter {
            $0.toUserId != apply.toUserId
        }
        applyRelay.accept(value)
        reload.onNext(())
    }
}
