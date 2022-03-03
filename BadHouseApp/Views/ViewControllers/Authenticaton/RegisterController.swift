import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

final class RegisterController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var alreadyButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel: RegisterViewModel
    private var currentNonce: String?
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleRegister), for: .touchUpInside)
        return button
    }()
    private lazy var  googleView: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        button.addTarget(self, action: #selector(didTapGidButton), for: .touchUpInside)
        return button
    }()
    
    var coordinator: RegisterFlow?
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupGoogleLogin()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    // MARK: - SetupMethod
    private func setupGoogleLogin() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        stackView.addArrangedSubview(googleView)
        stackView.addArrangedSubview(appleButton)
        googleView.anchor(height: 40)
        appleButton.anchor(height: 40)
    }

    private func setupBinding() {
        
        nameTextField.rx.text.orEmpty
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.nameTextInput.onNext(text)
            }.disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.emailTextInput.onNext(text)
            }.disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text)
            }.disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self  = self else { return }
                self.viewModel.didTapRegisterButton()
            }.disposed(by: disposeBag)
        
        viewModel.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
            }.disposed(by: disposeBag)
        
        alreadyButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.toLogin()
            }.disposed(by: disposeBag)
        
        viewModel.errorHandling.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            self.signUpErrAlert(error as NSError)
        }).disposed(by: disposeBag)
        
        viewModel.isCompleted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.toMain()
        }.disposed(by: disposeBag)
    }

    @objc private func didTapGidButton() {
        GIDSignIn.sharedInstance()?.signIn()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    func signUpErrAlert(_ error: NSError) {
        let message = setupErrorMessage(error: error)
        self.showCDAlert(title: R.alertMessage.notRegister,
                          message: message,
                         action: R.alertMessage.ok,
                          alertType: .error)
    }
    // MARK: - SelectorMethod
    @objc private func appleRegister() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
// MARK: - GIDSignInDelegate
extension RegisterController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        } else {
            let fullName = user.profile.name
            let email = user.profile.email
            guard let auth = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil {
                    return
                } else {
                    guard let id = result?.user.uid else { return }
                    guard let email = email else { return }
                    guard let name = fullName else { return }
                    let credential = AuthCredential(name: name, email: email, password: "")
                    self.viewModel.thirdPartyLogin(credential: credential, id: id)
                }
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(error.localizedDescription)
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension RegisterController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let name = appleCredential.fullName?.givenName else {
                return
            }
            guard let idToken = appleCredential.identityToken else { return }
            guard let nonce = currentNonce else { return }
            guard let idTokenString = String(data: idToken,
                                             encoding: .utf8) else { return }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    guard let email = result?.user.email else { return }
                    guard let uid = result?.user.uid else { return }
                    let credential = AuthCredential(name: name, email: email, password: "")
                    self.viewModel.thirdPartyLogin(credential: credential, id: uid)
                }
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
// MARK: - ASAuthorizationControllerPresentationContextProviding
extension RegisterController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
