import RxSwift
import FirebaseAuth
import RxRelay
import ReSwift

protocol HomeViewModelInputs {
    func didLoad()
    func search(_ practices: [Practice])
    func refresh()
    var willAppear: PublishRelay<Void> { get }
    var willDisAppear: PublishRelay<Void> { get }
}

protocol HomeViewModelOutputs {
    var isNetWorkError: PublishSubject<Void> { get }
    var isAuth: PublishSubject<Void> { get }
    var isError: PublishSubject<Bool> { get }
    var practiceRelay: BehaviorRelay<[Practice]> { get }
    var reload: PublishSubject<Void> { get }
    var isIndicatorAnimating: PublishSubject<Bool> { get }
    var isRefreshAnimating: PublishSubject<Bool> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelType {
    
    var isNetWorkError: PublishSubject<Void> = PublishSubject<Void>()
    var isAuth: PublishSubject<Void> = PublishSubject<Void>()
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var practiceRelay = BehaviorRelay<[Practice]>(value: [])
    var practiceAPI: PracticeServieProtocol
    var reload = PublishSubject<Void>()
    var isIndicatorAnimating = PublishSubject<Bool>()
    var isRefreshAnimating = PublishSubject<Bool>()
    let willDisAppear = PublishRelay<Void>()
    let willAppear = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let store: Store<AppState>
    private let actionCreator: HomeActionCreator
    
    init(practiceAPI: PracticeServieProtocol, store: Store<AppState>, actionCreator: HomeActionCreator) {
        self.practiceAPI = practiceAPI
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe { [unowned self] _ in
            self.store.subscribe(self) { subscription in
                subscription.select({ $0.homeState })
            }
            self.willAppearAction()
        }.disposed(by: disposeBag)
        
        willDisAppear.subscribe { [unowned self] _ in
            self.store.unsubscribe(self)
        }.disposed(by: disposeBag)

        self.actionCreator.getPractices()
    }
    
    func didLoad() {
        actionCreator.saveFriend()
    }
    
    func willAppearAction() {
        
        if Auth.auth().currentUser == nil {
            isAuth.onNext(())
        } else if !Network.shared.isOnline() {
            isNetWorkError.onNext(())
        } else {
            actionCreator.getPractices()
        }
    }
    
    func search(_ practices: [Practice]) {
        practiceRelay.accept(practices)
    }
    
    func refresh() {
        actionCreator.getPractices()
    }
    
}

extension HomeViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = HomeState
    
    func newState(state: HomeState) {
        self.practiceRelay.accept(state.practices)
        self.isRefreshAnimating.onNext(state.isRefreshAnimating)
        self.isIndicatorAnimating.onNext(state.isIndicatorAnimating)
        
        state.reload.subscribe { [weak self] _ in
            self?.reload.onNext(())
        }.disposed(by: disposeBag)
    }
}
