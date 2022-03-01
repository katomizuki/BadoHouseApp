import RxSwift
import RxCocoa
import Firebase
// MARK: - Input Protocol
protocol RegisterBindingInputs {
    var nameTextInput: AnyObserver<String> { get }
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
    func didTapRegisterButton()
}
// MARK: - OutputProtocol
protocol RegisterBindingsOutputs {
    var nameTextOutput: PublishSubject<String> { get }
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
    var errorHandling: PublishSubject<Error> { get }
    var isCompleted: PublishSubject<Bool> { get }
}
final class RegisterViewModel: RegisterBindingInputs, RegisterBindingsOutputs {
    
    private let disposeBag = DisposeBag()
    // MARK: - Observable(状態を保持している監視対象）
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    var errorHandling = PublishSubject<Error>()
    var isCompleted: PublishSubject<Bool> = PublishSubject<Bool>()
    var valideRegisterSubject = BehaviorSubject<Bool>(value: false)
    // MARK: - Observer(監視者)
    var nameTextInput: AnyObserver<String> {
        nameTextOutput.asObserver()
    }
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    var validRegisterDriver: Driver<Bool> = Driver.never()
    var name: String = String()
    var email: String = String()
    var password: String = String()
    var authAPI: AuthRepositry
    var userAPI: UserRepositry
    // MARK: - initialize
    init(authAPI: AuthRepositry, userAPI: UserRepositry) {
        self.authAPI = authAPI
        self.userAPI = userAPI
        validRegisterDriver = valideRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        let nameValid: Observable<Bool> = nameTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                self?.name = text
                return text.count >= 2
            }
        let emailValid: Observable<Bool> = emailTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                self?.email = text
                let atMarkCount = Array(text).filter { $0 == "@"}.count
                return text.count >= 5 && text.contains("@") && !text.contains(" ") && atMarkCount == 1
            }
        let passwordValid: Observable<Bool> = passwordTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                self?.password = text
                return text.count >= 6 && !text.contains(" ")
            }
        // Mark combine
        Observable.combineLatest(nameValid, emailValid, passwordValid) { $0 && $1 && $2 }
        .subscribe { validAll in
            self.valideRegisterSubject.onNext(validAll)
        }
        .disposed(by: disposeBag)
    }

    func didTapRegisterButton() {
        let credential = AuthCredential(name: name, email: email, password: password)

        authAPI.register(credential: credential).subscribe(onSuccess: { [weak self] dic in
            guard let self = self else { return }
            self.userAPI.postUser(uid: dic["uid"] as! String, dic: dic).subscribe(onCompleted: {
                self.isCompleted.onNext(true)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorHandling.onNext(error)
            }).disposed(by: self.disposeBag)
        }, onFailure: { [weak self] error  in
            self?.errorHandling.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func thirdPartyLogin(credential: AuthCredential, id: String) {
        let dic: [String: Any] = ["name": credential.name,
                                "uid": id,
                                "createdAt": Timestamp(),
                                "updatedAt": Timestamp(),
                                "email": credential.email]
        
        userAPI.postUser(uid: id, dic: dic).subscribe(onCompleted: {
            self.isCompleted.onNext(true)
        }, onError: { [weak self] error in
            self?.errorHandling.onNext(error)
        }).disposed(by: disposeBag)
    }
}
