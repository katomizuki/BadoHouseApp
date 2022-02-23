import RxRelay
import RxSwift

protocol ScheduleViewModelInputs {
    func willAppear()
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
    
    private let userAPI: UserRepositry
    var practiceAPI: PracticeRepositry
    
    var user: User
    var practiceList = BehaviorRelay<[Practice]>(value: [])
    private let disposeBag = DisposeBag()
    private let errorStream = PublishSubject<Bool>()
    private let reloadStream = PublishSubject<Void>()
    
    init(userAPI: UserRepositry, practiceAPI: PracticeRepositry, user: User) {
        self.userAPI = userAPI
        self.practiceAPI = practiceAPI
        self.user = user
    }
    
    func willAppear() {
        userAPI.getMyJoinPractice(user: user).subscribe {[weak self] practices in
            self?.practiceList.accept(practices)
            self?.reloadInput.onNext(())
        } onFailure: { [weak self] _ in
            self?.errorInput.onNext(true)
        }.disposed(by: disposeBag)
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
