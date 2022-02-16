import RxSwift
import RxRelay

protocol AdditionalMemberViewModelType {
    var inputs: AdditionalMemberViewModelInputs { get }
    var outputs: AdditionalMemberViewModelOutputs { get }
}

protocol AdditionalMemberViewModelInputs {
    func invite()
    var errorInput: AnyObserver<Bool> { get }
    var completedInput: AnyObserver<Void> { get }
}

protocol AdditionalMemberViewModelOutputs {
    var friendsSubject: BehaviorRelay<[User]> { get }
    var isError: Observable<Bool> { get }
    var completed: Observable<Void> { get }
}

final class AdditionalMemberViewModel: AdditionalMemberViewModelType {
    
    var inputs: AdditionalMemberViewModelInputs { return self }
    var outputs: AdditionalMemberViewModelOutputs { return self }
    
    lazy var inviteIds = circle.member
    var friendsSubject = BehaviorRelay<[User]>(value: [])
    
    private let errorStream = PublishSubject<Bool>()
    private let completedStream = PublishSubject<Void>()
    private let user: User
    private let userAPI: UserRepositry
    private let circle: Circle
    private let circleAPI: CircleRepositry
    private let disposeBag = DisposeBag()
    
    init(user: User,
         userAPI: UserRepositry,
         circle: Circle,
         circleAPI: CircleRepositry) {
        self.user = user
        self.userAPI = userAPI
        self.circle = circle
        self.circleAPI = circleAPI
        
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] friends in
            guard let self = self else { return }
            let users = self.judgeInviter(members: self.circle.members, friends: friends)
            self.friendsSubject.accept(users)
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func inviteAction(user: User?) {
        guard let user = user else { return }
        if judgeInvite(id: user.uid) {
            inviteIds.remove(value: user.uid)
        } else {
            inviteIds.append(user.uid)
        }
    }
    
    func judgeInvite(id: String) -> Bool {
        return inviteIds.contains(id)
    }
    
    func invite() {
        circleAPI.inviteCircle(ids: inviteIds, circle: circle) { result in
            switch result {
            case .success:
                self.completedInput.onNext(())
            case .failure:
                self.errorInput.onNext(true)
            }
        }
    }
    
    private func judgeInviter(members: [User], friends: [User]) -> [User] {
        var array = friends
        members.forEach {
            array.remove(value: $0)
        }
        return array
    }
}

extension AdditionalMemberViewModel: AdditionalMemberViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
    var completedInput: AnyObserver<Void> {
        completedStream.asObserver()
    }
}

extension AdditionalMemberViewModel: AdditionalMemberViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var completed: Observable<Void> {
        completedStream.asObservable()
    }
}
