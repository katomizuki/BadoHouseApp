import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import NVActivityIndicatorView
import GoogleSignIn
import AuthenticationServices
import CryptoKit

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let loginBinding = LoginViewModel()
    private var indicatorView: NVActivityIndicatorView!
    private let googleView: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    private let iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
        return iv
    }()
    private let emailTextField: UITextField = {
        let tf = RegisterTextField(placeholder: "メールアドレス")
        tf.tag = 0
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = RegisterTextField(placeholder: "パスワード")
        tf.tag = 1
        tf.returnKeyType = .done
        tf.keyboardType = .default
        tf.isSecureTextEntry = true
        return tf
    }()
    private let loginButton: UIButton = {
        let button = RegisterButton(text: "ログイン")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    private let dontHaveButton = UIButton(type: .system).createAuthButton(text: "新規登録の方はこちらへ")
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        return button
    }()
    private var currentNonce: String?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setupLayout()
        setupBinding()
        setupDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    // MARK: - SetupMethod
    private func setupLayout() {
        let basicStackView = UIStackView(arrangedSubviews: [emailTextField,
                                                            passwordTextField,
                                                            loginButton,
                                                            googleView,
                                                            appleButton])
        basicStackView.axis = .vertical
        basicStackView.distribution = .fillEqually
        basicStackView.spacing = 20
        view.addSubview(basicStackView)
        view.addSubview(iv)
        view.addSubview(dontHaveButton)
        emailTextField.anchor(height: 45)
        basicStackView.anchor(top: iv.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 20,
                              paddingRight: 20,
                              paddingLeft: 20,
                              height: 380)
        iv.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                  paddingTop: 30,
                  centerX: view.centerXAnchor,
                  width: 100,
                  height: 100)
        dontHaveButton.anchor(top: basicStackView.bottomAnchor,
                              paddingTop: 20,
                              centerX: view.centerXAnchor)
        dontHaveButton.addTarget(self, action: #selector(moveAlready), for: UIControl.Event.touchUpInside)
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
    }
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        fbButton.delegate = self
//        fbButton.permissions = ["public_profile, email"]
    }
    private func setupBinding() {
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.emailTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.emailTextField.layer.borderWidth = 3
                } else {
                    self?.emailTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.emailTextField.layer.borderWidth = 2
                }
                self?.loginBinding.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.passwordTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.passwordTextField.layer.borderWidth = 3
                } else {
                    self?.passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.passwordTextField.layer.borderWidth = 2
                }
                self?.loginBinding.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        loginButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.login()
            }
            .disposed(by: disposeBag)
        loginBinding.validRegisterDriver
            .drive { validAll in
                self.loginButton.isEnabled = validAll
                self.loginButton.backgroundColor = validAll ? Constants.AppColor.OriginalBlue : .darkGray
            }
            .disposed(by: disposeBag)
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
        print(#function)
        navigationController?.popViewController(animated: true)
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
        indicatorView.stopAnimating()
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        AuthService.loginFirebaseAuth(email: email, password: password) { result, error in
            if result {
                self.indicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                if let error = error as NSError? {
                    self.signInErrAlert(error)
                }
            }
        }
    }
    // MARK: - LoginError
    private func signInErrAlert(_ error: NSError) {
        print(#function)
        let message = setupErrorMessage(error: error)
        self.setupCDAlert(title: "ログインできませんでした", message: message, action: "OK", alertType: .error)
        indicatorView.stopAnimating()
    }
}
// MARK: - GoogleSigninDelegate
extension LoginViewController: GIDSignInDelegate {
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
//// MARK: - FacebookDelegate
//extension LoginViewController: LoginButtonDelegate {
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("logout fb")
//    }
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        if error == nil {
//            if result?.isCancelled == true {
//                return
//            }
//        }
//        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//        Auth.auth().signIn(with: credential) { (_, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else {
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
//    }
//}
// MARK: - TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
// MARK: - ASAuthorizationControllerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
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
                        print("success")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
