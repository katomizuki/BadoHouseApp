import RxRelay
import RxSwift
import ReSwift

protocol ScheduleViewModelInputs {
    func deleteSchdule(_ index: Int)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ScheduleViewModelOutputs {
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
    var practiceList: BehaviorRelay<[Practice]> { get }
}

protocol ScheduleViewModelType {
    var inputs: ScheduleViewModelInputs { get }
    var outputs: ScheduleViewModelOutputs { get }
}

final class ScheduleViewModel: ScheduleViewModelType {
  
    var inputs: ScheduleViewModelInputs { return self }
    var outputs: ScheduleViewModelOutputs { return self }
    
    private let user: User
    let practiceList = BehaviorRelay<[Practice]>(value: [])
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    private let store: Store<AppState>
    private let actionCreator: ScheduleActionCreator
    
    init(user: User, store: Store<AppState>, actionCreator: ScheduleActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.scheduleState }
            }
            self.getMyJoinPractice()
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    func getMyJoinPractice() {
        self.actionCreator.getMyJoinPractice(user: user)
    }
    func deleteSchdule(_ row: Int) {
        //  ここで削除する
    }
}

extension ScheduleViewModel: ScheduleViewModelInputs {

    var errorInput: AnyObserver<Bool> {
        errorStream.asObserver()
    }

    var reloadInput: AnyObserver<Void> {
        reloadStream.asObserver()
    }
}

extension ScheduleViewModel: ScheduleViewModelOutputs {

    var isError: Observable<Bool> {
        errorStream.asObservable()
    }

    var reload: Observable<Void> {
        reloadStream.asObservable()
    }
}
extension ScheduleViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = ScheduleState
    
    func newState(state: ScheduleState) {

        if state.reloadStatus {
            reloadInput.onNext(())
        }

        if state.errorStatus {
            errorInput.onNext(true)
        }
        
        practiceList.accept(state.practices)
    }
}
