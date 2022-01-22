import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase
import AuthenticationServices
import CryptoKit
protocol LoginFlow: AnyObject {
    func toRegister()
}
final class LoginController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var notRegisterButton: UIButton!
    @IBOutlet private weak var emailTextField: UITextField!
    var coordinator: LoginFlow?
    private var currentNonce: String?
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel(authAPI: AuthService(), userAPI: UserService())
    private let googleView: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        return button
    }()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setupBinding()
        setupGoogleLogin()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    private func setupGoogleLogin() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        stackView.addArrangedSubview(googleView)
        stackView.addArrangedSubview(appleButton)
        appleButton.anchor(height: 40)
    }
    private func setupBinding() {
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.emailTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        loginButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.login()
            }.disposed(by: disposeBag)
        
        viewModel.validRegisterDriver
            .drive { [weak self] validAll in
                guard let self = self else { return }
                self.loginButton.isEnabled = validAll
            }.disposed(by: disposeBag)
        
        notRegisterButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.toRegister()
        }).disposed(by: disposeBag)

    }
    // MARK: - HelperMethod
    private func sha256(input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)}.joined()
        return hashString
    }
    private func randomNonceString(length: Int = 32) -> String {
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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
    @objc private func appleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(input: nonce)
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }
    // MARK: - Login
    private func login() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        AuthService.login(email: email, password: password) { _, error in
            if let error = error {
                self.signInErrAlert(error as NSError)
                return
            }
            self.dismiss(animated: true)
        }
    }
    // MARK: - LoginError
    private func signInErrAlert(_ error: NSError) {
        let message = setupErrorMessage(error: error)
        self.showCDAlert(title: R.alertMessage.notLogin, message: message, action: R.alertMessage.ok, alertType: .error)
    }
}
// MARK: - GoogleSigninDelegate
extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            guard let auth = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension LoginController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let idToken = appleCredential.identityToken else { return }
                guard let nonce = currentNonce else { return }
                guard let idTokenString = String(data: idToken,
                                                 encoding: .utf8) else { return }
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Auth.auth().signIn(with: credential) { _, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
