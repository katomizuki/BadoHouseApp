import Foundation
import RxSwift
import FirebaseAuth
import RxRelay
protocol HomeViewModelInputs {
    func didLoad()
    func willAppear()
    func search(_ practices: [Practice])
    func refresh()
}
protocol HomeViewModelOutputs {
    var isNetWorkError: PublishSubject<Void> { get }
    var isAuth: PublishSubject<Void> { get }
    var isError: PublishSubject<Bool> { get }
    var practiceRelay: BehaviorRelay<[Practice]> { get }
    var reload: PublishSubject<Void> { get }
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
    private let disposeBag = DisposeBag()
    
    init(practiceAPI: PracticeServieProtocol) {
        self.practiceAPI = practiceAPI
        fetchPractices()
    }
    func didLoad() {
        if let uid =  Auth.auth().currentUser?.uid {
            UserService.saveFriendId(uid: uid)
        }
    }
    func willAppear() {
        
        if Auth.auth().currentUser == nil {
            isAuth.onNext(())
        } else if !Network.shared.isOnline() {
            isNetWorkError.onNext(())
        } else {
            fetchPractices()
        }
        
    }
    func search(_ practices: [Practice]) {
        practiceRelay.accept(practices)
    }
    func refresh() {
        fetchPractices()
    }
    private func fetchPractices() {
        practiceAPI.getPractices().subscribe { [weak self] practices in
            self?.practiceRelay.accept(practices)
            self?.reload.onNext(())
        } onFailure: { [weak self] _ in
            self?.isError.onNext(true)
        }.disposed(by: disposeBag)
    }
}
