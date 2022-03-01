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

    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
   
    var practiceRelay = BehaviorRelay<[Practice]>(value: [])
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
        
        willAppearStream.subscribe { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select({ $0.homeState }) }
            self.willAppearAction()
        }.disposed(by: disposeBag)
        
        willDisAppearStream.subscribe { [unowned self] _ in
            self.store.unsubscribe(self)
        }.disposed(by: disposeBag)
        
        didLoadStream.subscribe { [weak self] _ in
            self?.actionCreator.saveFriend()
        }.disposed(by: disposeBag)
        NSLog("⚡️")
    }
        
    func willAppearAction() {
        
        if let id = Auth.auth().currentUser?.uid {
            KeyChainRepositry.save(id: id)
            actionCreator.getPractices()
        } else if !Network.shared.isOnline() {
            isNetWorkErrorInput.onNext(())
        } else {
            isAuthInput.onNext(())
        }
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
        self.practiceRelay.accept(state.practices)
        self.isRefreshInput.onNext(state.isRefreshAnimating)
        self.indicatorInput.onNext(state.isIndicatorAnimating)
        
        state.reload
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.reloadInput.onNext(())
        }.disposed(by: disposeBag)
    }
}
