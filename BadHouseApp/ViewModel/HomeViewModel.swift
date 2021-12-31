import Foundation
import RxSwift
import FirebaseAuth
import RxRelay
protocol HomeViewModelInputs {
    func didLoad()
    func willAppear()
}
protocol HomeViewModelOutputs {
    var isNetWorkError: PublishSubject<Void> { get }
    var isAuth: PublishSubject<Void> { get }
    var isError: PublishSubject<Bool> { get }
    var practiceRelay: BehaviorRelay<[Practice]> { get }
}
protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}
final class HomeViewModel:HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelType {
    var isNetWorkError: PublishSubject<Void> = PublishSubject<Void>()
    var isAuth: PublishSubject<Void> = PublishSubject<Void>()
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
    var isError = PublishSubject<Bool>()
    var practiceRelay = BehaviorRelay<[Practice]>(value: [])
    var practiceAPI: PracticeServieProtocol
    private let disposeBag = DisposeBag()
    init(practiceAPI: PracticeServieProtocol) {
        self.practiceAPI = practiceAPI
        practiceAPI.getPractices().subscribe { [weak self] practices in
            self?.practiceRelay.accept(practices)
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)

    }
    func didLoad() {
        if let uid =  Auth.auth().currentUser?.uid {
            UserService.saveFriendId(uid: uid)
        }
    }
    func willAppear() {
        if !Network.shared.isOnline() {
            isNetWorkError.onNext(())
        }
        if Auth.auth().currentUser == nil {
            isAuth.onNext(())
        }
    }
}
