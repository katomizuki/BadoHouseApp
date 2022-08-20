import RxRelay
import RxSwift
import ReSwift
import Domain

protocol ScheduleViewModelInputs {
    func deleteSchdule(_ index: Int)
    var errorInput: AnyObserver<Bool> { get }
    var reloadInput: AnyObserver<Void> { get }
}

protocol ScheduleViewModelOutputs {
    var isError: Observable<Bool> { get }
    var reload: Observable<Void> { get }
    var practiceList: BehaviorRelay<[Domain.Practice]> { get }
}

protocol ScheduleViewModelType {
    var inputs: ScheduleViewModelInputs { get }
    var outputs: ScheduleViewModelOutputs { get }
}

final class ScheduleViewModel: ScheduleViewModelType {
  
    var inputs: any ScheduleViewModelInputs { self }
    var outputs: any ScheduleViewModelOutputs { self }
    
    let user: Domain.UserModel
    let practiceList = BehaviorRelay<[Domain.Practice]>(value: [])
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()
    
    private let store: Store<AppState>
    private let actionCreator: ScheduleActionCreator
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    init(user: Domain.UserModel,
         store: Store<AppState>,
         actionCreator: ScheduleActionCreator) {
        self.user = user
        self.store = store
        self.actionCreator = actionCreator
        
        setupSubscribe()
    }
    
    func setupSubscribe() {
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
        actionCreator.getMyJoinPractice(user: user)
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
        errorStateSubscribe(state)
        reloadStateSubscribe(state)
        practiceStateSubscribe(state)
    }
    
    func errorStateSubscribe(_ state: ScheduleState) {
        if state.errorStatus {
            errorInput.onNext(true)
            actionCreator.toggleErrorStatus()
        }
    }
    
    func reloadStateSubscribe(_ state: ScheduleState) {
        if state.reloadStatus {
            reloadInput.onNext(())
            actionCreator.toggleReloadStatus()
        }
    }
    
    func practiceStateSubscribe(_ state: ScheduleState) {
        practiceList.accept(state.practices)
    }
}
