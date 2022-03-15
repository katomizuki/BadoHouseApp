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
    
    var inputs: any SearchUserViewModelInputs { self }
    var outputs: any SearchUserViewModelOutputs { self }

    let usersRelay = BehaviorRelay<[User]>(value: [])
    let user: User
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()

    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let searchTextStream = PublishSubject<String>()
    private let store: Store<AppState>
    private let actionCreator: SearchUserActionCreator
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: SearchUserActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
        searchFriends()
        
    }
    
    private func searchFriends() {
        searchTextOutputs.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.actionCreator.search(text)
        }).disposed(by: disposeBag)
    }
    
    private func setupSubscribe() {
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
        actionCreator.applyFriend(user, myData: myData)
    }
    
    func notApplyFriend(_ user: User, myData: User) {
        actionCreator.notApplyFriend(user, myData: myData)
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
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleError()
        }
        usersRelay.accept(state.users)
    }
}
