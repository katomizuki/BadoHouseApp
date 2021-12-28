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
    var isApplyViewHidden:PublishSubject<Bool> { get }
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
    var user:User?
    private let disposeBag = DisposeBag()
    init(userAPI: UserServiceProtocol) {
        self.userAPI = userAPI
    }
    func willAppear() {
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
    
    func didTapPermissionButton() {
        
    }
    
}
