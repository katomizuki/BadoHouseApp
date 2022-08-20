import RxSwift
import RxRelay
import ReSwift
import Domain

protocol MyPracticeViewModelType {
    var inputs: MyPracticeViewModelInputs { get }
    var outputs: MyPracticeViewModelOutputs { get }
}

protocol MyPracticeViewModelInputs {
    func deletePractice(_ practice: Domain.Practice)
    var errorInput: AnyObserver<Bool> { get }
}

protocol MyPracticeViewModelOutputs {
    var practices: BehaviorRelay<[Domain.Practice]> { get }
    var isError: Observable<Bool> { get }
}

final class MyPracticeViewModel: MyPracticeViewModelType {
    
    var inputs: any MyPracticeViewModelInputs { self }
    var outputs: any MyPracticeViewModelOutputs { self }
    
    let practices = BehaviorRelay<[Domain.Practice]>(value: [])
    let myData: Domain.UserModel
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let actionCreator: MyPracticeActionCreator
    private let store: Store<AppState>
    
    init(myData: Domain.UserModel,
         store: Store<AppState>,
         actionCreator: MyPracticeActionCreator) {
        self.myData = myData
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
    }
    
    func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.myPracticeState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func deletePractice(_ practice: Domain.Practice) {
        actionCreator.deletePractice(practice, myData: myData)
    }
}

extension MyPracticeViewModel: MyPracticeViewModelInputs {
    
    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }
}
extension MyPracticeViewModel: MyPracticeViewModelOutputs {
    
    var isError: Observable<Bool> {
        errorStream.asObservable()
    }
}

extension MyPracticeViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = MyPracticeState
    
    func newState(state: MyPracticeState) {
        practiceStateSubscribe(state)
        errorStateSubscribe(state)
    }
    
    func practiceStateSubscribe(_ state: MyPracticeState) {
        practices.accept(state.practices)
    }
    
    func errorStateSubscribe(_ state: MyPracticeState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
}
