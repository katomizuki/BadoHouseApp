import RxSwift
import RxRelay
import ReSwift

protocol MyPracticeViewModelType {
    var inputs: MyPracticeViewModelInputs { get }
    var outputs: MyPracticeViewModelOutputs { get }
}

protocol MyPracticeViewModelInputs {
    func deletePractice(_ practice: Practice)
    var errorInput: AnyObserver<Bool> { get }
}

protocol MyPracticeViewModelOutputs {
    var practices: BehaviorRelay<[Practice]> { get }
    var isError: Observable<Bool> { get }
}

final class MyPracticeViewModel: MyPracticeViewModelType {
    
    var inputs: MyPracticeViewModelInputs { return self }
    var outputs: MyPracticeViewModelOutputs { return self }
    
    var practices = BehaviorRelay<[Practice]>(value: [])
    let user: User
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    var willAppear = PublishRelay<Void>()
    var willDisAppear = PublishRelay<Void>()
    private let actionCreator: MyPracticeActionCreator
    private let store: Store<AppState>
    
    init(user: User,
         store: Store<AppState>,
         actionCreator: MyPracticeActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.myPracticeState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)

    }
    
    func deletePractice(_ practice: Practice) {
        DeleteService.deleteSubCollectionData(collecionName: R.Collection.Users, documentId: user.uid, subCollectionName: R.Collection.Practice, subId: practice.id)
        DeleteService.deleteCollectionData(collectionName: R.Collection.Practice, documentId: practice.id)
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
        practices.accept(state.practices)
        if state.errorStatus {
            errorInput.onNext(true)
        }
    }
}
