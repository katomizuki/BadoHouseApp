import RxSwift
import RxCocoa

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
    var errorHandling:PublishSubject<Error> { get }
    var isCompleted:PublishSubject<Bool> { get }
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
    var authAPI: AuthServiceProtocol
    var firebaseAPI:FirebaseServiceProtocol
    // MARK: - initialize
    init(authAPI:AuthServiceProtocol,firebaseAPI:FirebaseServiceProtocol) {
        self.authAPI = authAPI
        self.firebaseAPI = firebaseAPI
        validRegisterDriver = valideRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        let nameValid = nameTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                self?.name = text
                return text.count >= 2
            }
        let emailValid = emailTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                self?.email = text
                let atMarkCount = Array(text).filter { $0 == "@"}.count
                return text.count >= 5 && text.contains("@") && !text.contains(" ") && atMarkCount == 1
            }
        let passwordValid = passwordTextOutput
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
        authAPI.register(credential: credential) { [weak self] result in
            switch result {
            case .success(let dic):
                self?.firebaseAPI.postData(id: dic["uid"] as! String, dic: dic, ref: Ref.UsersRef, completion: { result in
                    switch result {
                    case .success:
                        self?.isCompleted.onNext(true)
                    case .failure(let error):
                        self?.errorHandling.onNext(error)
                    }
                })
            case .failure(let error):
                self?.errorHandling.onNext(error)
            }
        }
    }
}
