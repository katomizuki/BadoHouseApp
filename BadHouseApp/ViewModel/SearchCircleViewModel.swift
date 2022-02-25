import RxSwift
import RxRelay
import ReSwift

protocol SearchCircleViewModelInputs {
    var searchBarTextInput: AnyObserver<String> { get }
    var errorInput: AnyObserver<Bool> { get }
}

protocol SearchCircleViewModelOutputs {
    var circleRelay: BehaviorRelay<[Circle]> { get }
    var isError: Observable<Bool> { get }
}

protocol SearchCircleViewModelType {
    var inputs: SearchCircleViewModelInputs { get }
    var outputs: SearchCircleViewModelOutputs { get }
}

final class SearchCircleViewModel: SearchCircleViewModelType {

    var inputs: SearchCircleViewModelInputs { return self }
    var outputs: SearchCircleViewModelOutputs { return self }
    
    private let disposeBag = DisposeBag()
    private let searchBarText = PublishSubject<String>()
    let circleRelay = BehaviorRelay<[Circle]>(value: [])
    let user: User
    private let errorStream = PublishSubject<Bool>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: SearchCircleActionCreator
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: SearchCircleActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.searchCircleState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
        
        searchBarText.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.actionCreator.search(text)
        }).disposed(by: disposeBag)
    }
    
}
extension SearchCircleViewModel: SearchCircleViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }

    var searchBarTextInput: AnyObserver<String> {
        return searchBarText.asObserver()
    }
    
}

extension SearchCircleViewModel: SearchCircleViewModelOutputs {

    var isError: Observable<Bool> {
        errorStream.asObservable()
    }

}
extension SearchCircleViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = SearchCircleState
    
    func newState(state: SearchCircleState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleError()
        }
        
        circleRelay.accept(state.circles)
    }
}
