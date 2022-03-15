import RxSwift
import FirebaseAuth
import RxRelay
import ReSwift

protocol HomeViewModelInputs {
    func search(_ practices: [Practice])
    var didLoadInput: AnyObserver<Void> { get }
    func refresh()
    var reloadInput: AnyObserver<Void> { get }
    var willAppear: AnyObserver<Void> { get }
    var willDisAppear: AnyObserver<Void> { get }
    var isAuthInput: AnyObserver<Void> { get }
    var isNetWorkErrorInput: AnyObserver<Void> { get }
    var indicatorInput: AnyObserver<Bool> { get }
    var isRefreshInput: AnyObserver<Bool> { get }
}

protocol HomeViewModelOutputs {
    var isNetWorkError: Observable<Void> { get }
    var isAuth: Observable<Void> { get }
    var isError: Observable<Bool> { get }
    var practiceRelay: BehaviorRelay<[Practice]> { get }
    var reload: Observable<Void> { get }
    var isIndicatorAnimating: Observable<Bool> { get }
    var isRefreshAnimating: Observable<Bool> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelType {

    var inputs: any HomeViewModelInputs { return self }
    var outputs: any HomeViewModelOutputs { return self }
    
    var myData: User?
    
    let practiceRelay = BehaviorRelay<[Practice]>(value: [])
    
    private let didLoadStream = PublishSubject<Void>()
    private let willAppearStream = PublishSubject<Void>()
    private let willDisAppearStream = PublishSubject<Void>()
    private let refreshStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    private let newWorkErrorStream = PublishSubject<Void>()
    private let authStream = PublishSubject<Void>()
    private let errorStream = PublishSubject<Bool>()
    private let indicatorStream = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: HomeActionCreator
    
    init(store: Store<AppState>, actionCreator: HomeActionCreator) {
        self.store = store
        self.actionCreator = actionCreator
        setupSubscribe()
    }
    
    func setupSubscribe() {
        willAppearStream.subscribe { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select({ $0.homeState }) }
            checkIsAuthUser()
        }.disposed(by: disposeBag)
        
        willDisAppearStream.subscribe { [unowned self] _ in
            self.store.unsubscribe(self)
        }.disposed(by: disposeBag)
    }
        
    func checkIsAuthUser() {
        // TODO: ここにロジック書くのははあんまし良くない
        if let id = Auth.auth().currentUser?.uid {
           setupData(id)
        } else if !Network.shared.isOnline() {
            isNetWorkErrorInput.onNext(())
        } else {
            isAuthInput.onNext(())
        }
    }
    
    private func setupData(_ id: String) {
        actionCreator.saveId(id)
        actionCreator.getPractices()
        actionCreator.getUser(id: id)
        actionCreator.saveFriend()
    }
    
    func search(_ practices: [Practice]) {
        practiceRelay.accept(practices)
    }
}

// MARK: - Input
extension HomeViewModel: HomeViewModelInputs {
    
    func refresh() {
        actionCreator.getPractices()
    }
    
    var willDisAppear: AnyObserver<Void> {
        willDisAppearStream.asObserver()
    }
    
    var willAppear: AnyObserver<Void> {
        willAppearStream.asObserver()
    }
    
    var didLoadInput: AnyObserver<Void> {
        didLoadStream.asObserver()
    }
    
    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
    
    var isAuthInput: AnyObserver<Void> {
        authStream.asObserver()
    }
    
    var isNetWorkErrorInput: AnyObserver<Void> {
        newWorkErrorStream.asObserver()
    }
    
    var indicatorInput: AnyObserver<Bool> {
        indicatorStream.asObserver()
    }
    
    var isRefreshInput: AnyObserver<Bool> {
        refreshStream.asObserver()
    }
}

// MARK: - Output
extension HomeViewModel: HomeViewModelOutputs {
    var isAuth: Observable<Void> {
        authStream.asObservable()
    }
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
    
    var isNetWorkError: Observable<Void> {
        newWorkErrorStream.asObservable()
    }
    
    var isRefreshAnimating: Observable<Bool> {
        refreshStream.asObservable()
    }
    
    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
    
    var isIndicatorAnimating: Observable<Bool> {
        indicatorStream.asObservable()
    }
    
}

// MARK: - StoreSubscriber
extension HomeViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = HomeState
    
    func newState(state: HomeState) {
        practiceStateSubscribe(state)
        isRefreshStateSubscribe(state)
        indicatorStateSubscribe(state)
        userStateSubscribe(state)
        reloadStateSubscribe(state)
    }
    
    func practiceStateSubscribe(_ state: HomeState) {
        practiceRelay.accept(state.practices)
    }
    
    func isRefreshStateSubscribe(_ state: HomeState) {
        isRefreshInput.onNext(state.isRefreshAnimating)
    }
    
    func indicatorStateSubscribe(_ state: HomeState) {
        indicatorInput.onNext(state.isIndicatorAnimating)
    }
    
    func userStateSubscribe(_ state: HomeState) {
        if let user = state.user {
            self.myData = user
        }
    }
    
    func reloadStateSubscribe(_ state: HomeState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
}
