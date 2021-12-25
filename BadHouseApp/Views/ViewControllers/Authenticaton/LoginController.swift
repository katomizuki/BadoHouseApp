import UIKit
import Foundation
import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa
import GoogleSignIn
import Firebase
import AuthenticationServices
import CryptoKit
protocol LoginFlow:AnyObject {
    func toRegister()
}
final class LoginController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let loginBinding = LoginViewModel()
    private let googleView: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    private var currentNonce: String?
    var coordinator:LoginFlow?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setupBinding()
        setupGoogleLogin()
        view.backgroundColor = .blue
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    private func setupGoogleLogin() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    private func setupBinding() {
//        emailTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text?.count != 0 {
//                    self?.emailTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.emailTextField.layer.borderWidth = 3
//                } else {
//                    self?.emailTextField.layer.borderColor = UIColor.darkGray.cgColor
//                    self?.emailTextField.layer.borderWidth = 2
//                }
//                self?.loginBinding.emailTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        passwordTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text?.count != 0 {
//                    self?.passwordTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.passwordTextField.layer.borderWidth = 3
//                } else {
//                    self?.passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
//                    self?.passwordTextField.layer.borderWidth = 2
//                }
//                self?.loginBinding.passwordTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        loginButton.rx.tap
//            .asDriver()
//            .drive { [weak self] _ in
//                self?.login()
//            }
//            .disposed(by: disposeBag)
//        loginBinding.validRegisterDriver
//            .drive { validAll in
//
//            }
//            .disposed(by: disposeBag)
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
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
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
    // MARK: - SelectorMethod
    @objc private func moveAlready() {
        coordinator?.toRegister()
    }
    @objc private func appleLogin() {
        print(#function)
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
        print(#function)
//        let email = emailTextField.text ?? ""
//        let password = passwordTextField.text ?? ""
//        AuthService.loginFirebaseAuth(email: email, password: password) { result, error in
//            if result {
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                if let error = error as NSError? {
//                    self.signInErrAlert(error)
//                }
//            }
//        }
    }
    // MARK: - LoginError
    private func signInErrAlert(_ error: NSError) {
        print(#function)
        let message = setupErrorMessage(error: error)
        self.showCDAlert(title: "ログインできませんでした", message: message, action: "OK", alertType: .error)
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

