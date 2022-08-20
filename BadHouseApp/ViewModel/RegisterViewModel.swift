import RxSwift
import RxCocoa
import Firebase
import ReSwift
import Infra
import Domain


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
    // MARK: - Observable(状態を保持している監視対象）
    let nameTextOutput = PublishSubject<String>()
    let emailTextOutput = PublishSubject<String>()
    let passwordTextOutput = PublishSubject<String>()
    let errorHandling = PublishSubject<Error>()
    let isCompleted: PublishSubject<Bool> = PublishSubject<Bool>()
    let valideRegisterSubject = BehaviorSubject<Bool>(value: false)
    let willAppear = PublishRelay<Void>()
    let willDisAppear = PublishRelay<Void>()

    private let store: Store<AppState>
    private let authAPI: any AuthRepositry
    private let userAPI: any UserRepositry
    private let disposeBag = DisposeBag()
    private let actionCreator: RegisterActionCreator
    // MARK: - initialize
    init(authAPI: AuthRepositry,
         userAPI: UserRepositry,
         store: Store<AppState>,
         actionCreator: RegisterActionCreator) {
        self.authAPI = authAPI
        self.userAPI = userAPI
        self.store = store
        self.actionCreator = actionCreator
        
        setupValidation()
        setupSubscribe()
    }
    
    private func setupSubscribe() {
        willAppear.subscribe(onNext: { [unowned self] _ in
            self.store.subscribe(self) { subcription in
                subcription.select { state in state.registerState }
            }
        }).disposed(by: disposeBag)
        
        willDisAppear.subscribe(onNext: { [unowned self] _ in
            self.store.unsubscribe(self)
        }).disposed(by: disposeBag)
    }
    
    private func setupValidation() {
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
                guard let self = self else { return false }
                self.email = text
                let atMarkCount = self.makeAtMarkCount(text)
                return self.validateMailAddress(text, atMarkCount: atMarkCount)
            }
        
        let passwordValid: Observable<Bool> = passwordTextOutput
            .asObservable()
            .map { [weak self] text -> Bool in
                guard let self = self else { return false }
                self.password = text
                return self.validatePassword(text)
            }

        Observable.combineLatest(nameValid, emailValid, passwordValid) { $0 && $1 && $2 }
        .subscribe { validAll in
            self.valideRegisterSubject.onNext(validAll)
        }.disposed(by: disposeBag)
    }
    
    private func validateMailAddress(_ mailAddress: String, atMarkCount: Int) -> Bool {
        return mailAddress.count >= 5 && mailAddress.contains("@") && !mailAddress.contains(" ") && atMarkCount == 1
    }
    
    private func makeAtMarkCount(_ mailAddress: String) -> Int {
        return Array(mailAddress).filter { $0 == "@"}.count
    }
    
    private func validatePassword(_ password: String) -> Bool {
        return password.count >= 6 && !password.contains(" ")
    }

    func didTapRegisterButton() {
        let credential = Domain.AuthCredential(name: name,
                                               email: email,
                                               password: password)
// TODO: - ここら辺は要修正
        authAPI.register(credential: credential).subscribe(onSuccess: { [weak self] dic in
            guard let self = self else { return }
            self.userAPI.postUser(uid: dic["uid"] as! String, dic: dic).subscribe(onCompleted: {
                self.isCompleted.onNext(true)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.errorHandling.onNext(error)
            }).disposed(by: self.disposeBag)
        }, onFailure: { [weak self] error in
            guard let self = self else { return }
            self.errorHandling.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func thirdPartyLogin(credential: Domain.AuthCredential,
                         id: String) {
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

extension RegisterViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = RegisterState
    
    func newState(state: RegisterState) {
        
    }
}
