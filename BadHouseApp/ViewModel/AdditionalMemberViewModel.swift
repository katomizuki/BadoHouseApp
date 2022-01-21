import RxSwift
import RxRelay

protocol AdditionalMemberViewModelType {
    var inputs: AdditionalMemberViewModelInputs { get }
    var outputs: AdditionalMemberViewModelOutputs { get }
}

protocol AdditionalMemberViewModelInputs {
    func invite()
}

protocol AdditionalMemberViewModelOutputs {
    var friendsSubject: BehaviorRelay<[User]> { get }
    var isError: PublishSubject<Bool> { get }
    var completed: PublishSubject<Void> { get }
}

final class AdditionalMemberViewModel: AdditionalMemberViewModelType, AdditionalMemberViewModelInputs, AdditionalMemberViewModelOutputs {
    var inputs: AdditionalMemberViewModelInputs { return self }
    var outputs: AdditionalMemberViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var completed = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    lazy var inviteIds = circle.member
    var friendsSubject = BehaviorRelay<[User]>(value: [])
    var user: User
    let userAPI: UserServiceProtocol
    var circle: Circle
    let circleAPI: CircleServiceProtocol
    
    init(user: User,
         userAPI: UserServiceProtocol,
         circle: Circle,
         circleAPI: CircleServiceProtocol) {
        self.user = user
        self.userAPI = userAPI
        self.circle = circle
        self.circleAPI = circleAPI
        userAPI.getFriends(uid: user.uid).subscribe { [weak self] friends in
            guard let self = self else { return }
            let users = self.judgeInviter(members: self.circle.members, friends: friends)
            self.friendsSubject.accept(users)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
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
                self.completed.onNext(())
            case .failure:
                self.isError.onNext(true)
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
