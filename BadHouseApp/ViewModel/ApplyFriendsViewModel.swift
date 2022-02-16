import RxSwift
import FirebaseAuth
import RxRelay

protocol ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { get }
    var outputs: ApplyFriendsViewModelOutputs { get }
}

protocol ApplyFriendsViewModelInputs {
    func onTrashButton(apply: Apply)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ApplyFriendsViewModelOutputs {
    var applyRelay: BehaviorRelay<[Apply]> { get }
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
}

final class ApplyFriendsViewModel: ApplyFriendsViewModelType {
    var inputs: ApplyFriendsViewModelInputs { return self }
    var outputs: ApplyFriendsViewModelOutputs { return self }
    
    var applyRelay = BehaviorRelay<[Apply]>(value: [])
    private let user: User
    private let applyAPI: ApplyRepositry
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    init(user: User, applyAPI: ApplyRepositry) {
        self.user = user
        self.applyAPI = applyAPI
        
        applyAPI.getApplyUser(user: user).subscribe {[weak self] apply in
            self?.applyRelay.accept(apply)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
}

extension ApplyFriendsViewModel: ApplyFriendsViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    func onTrashButton(apply: Apply) {
        applyAPI.notApplyFriend(uid: self.user.uid, toUserId: apply.toUserId)
        let value = applyRelay.value.filter {
            $0.toUserId != apply.toUserId
        }
        applyRelay.accept(value)
        reloadInput.onNext(())
    }
}

extension  ApplyFriendsViewModel: ApplyFriendsViewModelOutputs {
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}

