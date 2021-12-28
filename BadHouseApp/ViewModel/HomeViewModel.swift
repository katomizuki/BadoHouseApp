import Foundation
import RxSwift
import FirebaseAuth
protocol HomeViewModelInputs {
    func didLoad()
    func willAppear()
}
protocol HomeViewModelOutputs {
    var isNetWorkError: PublishSubject<Void> { get }
    var isAuth: PublishSubject<Void> { get }
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
