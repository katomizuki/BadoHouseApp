import RxRelay
import RxSwift

protocol ScheduleViewModelInputs {
    func willAppear()
    func deleteSchdule(_ index: Int)
}

protocol ScheduleViewModelOutputs {
    var isError: PublishSubject<Bool> { get }
    var reload: PublishSubject<Void> { get }
    var practiceList: BehaviorRelay<[Practice]> { get }
}

protocol ScheduleViewModelType {
    var inputs: ScheduleViewModelInputs { get }
    var outputs: ScheduleViewModelOutputs { get }
}

final class ScheduleViewModel: ScheduleViewModelType, ScheduleViewModelInputs, ScheduleViewModelOutputs {
  
    var inputs: ScheduleViewModelInputs { return self }
    var outputs: ScheduleViewModelOutputs { return self }
    
    private let userAPI: UserRepositry
    var practiceAPI: PracticeRepositry
    var isError = PublishSubject<Bool>()
    var reload = PublishSubject<Void>()
    var user: User
    var practiceList = BehaviorRelay<[Practice]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(userAPI: UserRepositry, practiceAPI: PracticeRepositry, user: User) {
        self.userAPI = userAPI
        self.practiceAPI = practiceAPI
        self.user = user
    }
    
    func willAppear() {
        userAPI.getMyJoinPractice(user: user).subscribe {[weak self] practices in
            self?.practiceList.accept(practices)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
    func deleteSchdule(_ row: Int) {
        //  ここで削除する
    }
}
