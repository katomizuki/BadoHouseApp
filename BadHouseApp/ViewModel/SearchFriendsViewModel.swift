import RxSwift
import RxRelay

protocol SearchUserViewModelInputs {
    var searchTextInput: AnyObserver<String> { get }
}
protocol SearchUserViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var usersRelay: BehaviorRelay<[User]> { get }
    var searchTextOutputs: PublishSubject<String> { get }
}
protocol SearchUserViewModelType {
    var inputs: SearchUserViewModelInputs { get }
    var outputs: SearchUserViewModelOutputs { get }
}
final class SearchUserViewModel:SearchUserViewModelType, SearchUserViewModelInputs, SearchUserViewModelOutputs {
    var inputs: SearchUserViewModelInputs { return self }
    var outputs: SearchUserViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var usersRelay = BehaviorRelay<[User]>(value: [])
    var searchTextOutputs = PublishSubject<String>()
    var searchTextInput: AnyObserver<String> {
        return searchTextOutputs.asObserver()
    }
    private let disposeBag = DisposeBag()
    let user: User
    init(userAPI: UserServiceProtocol,user: User) {
        self.user = user
        searchTextOutputs.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            userAPI.searchUser(text: text).subscribe { [weak self] users in
                self?.usersRelay.accept(users)
            } onFailure: { [weak self] _ in
                self?.isError.onNext(true)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    func applyFriend(_ user: User, myData: User) {
        ApplyService.postApply(user: myData, toUser: user) { result in
            switch result {
            case .success:
                print(#function)
            case .failure:
                self.isError.onNext(true)
            }
        }
    }
    func notApplyFriend(_ user: User, myData: User) {
        ApplyService.notApplyFriend(uid: myData.uid, toUserId: user.uid)
    }
    
}
