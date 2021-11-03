import Foundation
import RxSwift
import RxCocoa

// MARK: - Input Protocol
protocol RegisterBindingInputs {
    var nameTextInput: AnyObserver<String> { get }
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}
// MARK: - OutputProtocol
protocol RegisterBindingsOutputs {
    var nameTextOutput: PublishSubject<String> { get }
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}
final class RegisterBindings: RegisterBindingInputs, RegisterBindingsOutputs {
    private let disposeBag = DisposeBag()
    // MARK: - Observable(状態を保持している監視対象）
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
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
    // MARK: - initialize
    init() {
        validRegisterDriver = valideRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        let nameValid = nameTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 2
            }
        let emailValid = emailTextOutput
            .asObservable()
            .map { text -> Bool in
                let atMarkCount = Array(text).filter { $0 == "@"}.count
                return text.count >= 5 && text.contains("@") && !text.contains(" ") && atMarkCount == 1
            }
        let passwordValid = passwordTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 6 && !text.contains(" ")
            }
        // Mark combine
        Observable.combineLatest(nameValid, emailValid, passwordValid) { $0 && $1 && $2 }
        .subscribe { validAll in
            self.valideRegisterSubject.onNext(validAll)
        }
        .disposed(by: disposeBag)
    }
}
// MARK: - InputProtocol
protocol LoginBindingInputs {
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}
// MARK: - OutputProtocol
protocol LoginBindingsOutputs {
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}
class LoginBindings: LoginBindingInputs, LoginBindingsOutputs {
    private let disposeBag = DisposeBag()
    // MARK: - Observable(状態を保持している監視対象）
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    var valideRegisterSubject = BehaviorSubject<Bool>(value: false)
    // MARK: - Observer(監視者)
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    var validRegisterDriver: Driver<Bool> = Driver.never()
    // MARK: - initialize
    init() {
        validRegisterDriver = valideRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        let emailValid = emailTextOutput
            .asObservable()
            .map { text -> Bool in
                let atMarkCount = Array(text).filter { $0 == "@"}.count
                return text.count >= 5 && text.contains("@") && !text.contains(" ") && atMarkCount == 1
            }
        let passwordValid = passwordTextOutput
            .asObservable()
            .map { text -> Bool in
                return text.count >= 6 && !text.contains(" ")
            }
        // MARK: - combine
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
        .subscribe { validAll in
            self.valideRegisterSubject.onNext(validAll)
        }
        .disposed(by: disposeBag)
    }
}
