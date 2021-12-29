import RxSwift
import Foundation
import RxCocoa
import FirebaseAuth

protocol UserViewModelInputs {
    func willAppear()
    func didTapPermissionButton()
}
protocol UserViewModelOutputs {
    var userName: BehaviorRelay<String> { get }
    var userUrl: BehaviorRelay<URL?> { get }
    var isError: PublishSubject<Bool> { get }
    var isApplyViewHidden: PublishSubject<Bool> { get }
}
protocol UserViewModelType {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}
final class UserViewModel: UserViewModelType, UserViewModelInputs, UserViewModelOutputs {
    var userName = BehaviorRelay<String>(value: "")
    var userUrl = BehaviorRelay<URL?>(value: nil)
    var isError = PublishSubject<Bool>()
    var isApplyViewHidden = PublishSubject<Bool>()
    var inputs: UserViewModelInputs { return self }
    var outputs: UserViewModelOutputs { return self }
    var userAPI: UserServiceProtocol
    var user: User?
    var applyAPI: ApplyServiceProtocol
    private let disposeBag = DisposeBag()
    init(userAPI: UserServiceProtocol,applyAPI:ApplyServiceProtocol) {
        self.userAPI = userAPI
        self.applyAPI = applyAPI
        if let uid = Auth.auth().currentUser?.uid {
            userAPI.getUser(uid: uid).subscribe(onSuccess: {[weak self] user in
                guard let self = self else { return }
                self.userName.accept(user.name)
                self.user = user
                if let url = URL(string: user.profileImageUrlString) {
                    self.userUrl.accept(url)
                } else {
                    self.userUrl.accept(nil)
                }
            }, onFailure: {[weak self] _ in
                guard let self = self else { return }
                self.isError.onNext(true)
            }).disposed(by: disposeBag)
        }
    }
    func willAppear() {
        if let user = user {
            applyAPI.getApplyedUser(user: user).subscribe {[weak self] applyed in
                self?.isApplyViewHidden.onNext(applyed.count == 0)
            } onFailure: { [weak self] _ in
                self?.isError.onNext(true)
            }.disposed(by: self.disposeBag)
        }
    }
    
    func didTapPermissionButton() {
        
    }
    
}
