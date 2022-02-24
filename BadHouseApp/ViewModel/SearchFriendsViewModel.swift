import RxSwift
import RxRelay
import ReSwift

protocol SearchUserViewModelInputs {
    var searchTextInput: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
}

protocol SearchUserViewModelOutputs {
    var isError: Observable<Bool> { get }
    var usersRelay: BehaviorRelay<[User]> { get }
    var searchTextOutputs: Observable<String> { get }
}

protocol SearchUserViewModelType {
    var inputs: SearchUserViewModelInputs { get }
    var outputs: SearchUserViewModelOutputs { get }
}

final class SearchUserViewModel: SearchUserViewModelType {
    
    var inputs: SearchUserViewModelInputs { return self }
    var outputs: SearchUserViewModelOutputs { return self }

    let usersRelay = BehaviorRelay<[User]>(value: [])
    let user: User

    private let disposeBag = DisposeBag()
    private let applyAPI: ApplyRepositry
    private let errorStream = PublishSubject<Bool>()
    private let searchTextStream = PublishSubject<String>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    
    init(userAPI: UserRepositry, user: User, applyAPI: ApplyRepositry, store: Store<AppState>) {
        self.user = user
        self.applyAPI = applyAPI
        self.store = store
        searchTextOutputs.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            userAPI.searchUser(text: text).subscribe { [weak self] users in
                self?.usersRelay.accept(users)
            } onFailure: { [weak self] _ in
                self?.errorInput.onNext(true)
            }.disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.searchUserState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func applyFriend(_ user: User, myData: User) {
        applyAPI.postApply(user: myData, toUser: user).subscribe {
            print(#function)
        } onError: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
    }
    
    func notApplyFriend(_ user: User, myData: User) {
        applyAPI.notApplyFriend(uid: myData.uid, toUserId: user.uid)
    }
    
}

extension SearchUserViewModel: SearchUserViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }

    var searchTextInput: AnyObserver<String> {
        searchTextStream.asObserver()
    }
}

extension SearchUserViewModel: SearchUserViewModelOutputs {

    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var searchTextOutputs: Observable<String> {
        searchTextStream.asObservable()
    }
    
}
extension SearchUserViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = SearchUserState
    
    func newState(state: SearchUserState) {
        
    }
}
