import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class RegisterController: UIViewController {
    // MARK: - Properties
        private let nameTextField: UITextField = {
        let tf = RegisterTextField(placeholder: "名前")
        tf.keyboardType = .default
        tf.returnKeyType = .next
        tf.tag = 0
        return tf
    }()
    private let emailTextField: UITextField = {
        let tf = RegisterTextField(placeholder: "メールアドレス")
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        tf.tag = 1
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = RegisterTextField(placeholder: "パスワード")
        tf.returnKeyType = .done
        tf.tag = 2
        tf.isSecureTextEntry = true
        return tf
    }()
    private let registerButton: UIButton = {
        let button = RegisterButton(text: "新規登録")
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    private let alreadyButton: UIButton = UIButton(type: .system).createAuthButton(text: "既にアカウントを持っている方はこちらへ")
    private let googleView: GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    private var displayName = String()
    private var pictureURL = String()
    private let iv: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
        return iv
    }()
    private let disposeBag = DisposeBag()
    private let registerBinding = RegisterViewModel()
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleRegister), for: .touchUpInside)
        return button
    }()
    private lazy var ruleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("利用規約", for: .normal)
        button.setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        button.addTarget(self, action: #selector(handleRuleButton), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    private var currentNonce: String?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        setupDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    // MARK: - SetupMethod
    private func setupDelegate() {
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField,
                                                       emailTextField,
                                                       passwordTextField,
                                                       registerButton,
                                                       googleView,
                                                       appleButton
                                                      ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        view.addSubview(stackView)
        view.addSubview(alreadyButton)
        view.addSubview(iv)
        view.addSubview(ruleButton)
        nameTextField.anchor(height: 45)
        stackView.anchor(top: iv.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingRight: 20,
                         paddingLeft: 20,
                         centerX: view.centerXAnchor,
                         height: 430)
        iv.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                  paddingTop: 30,
                  centerX: view.centerXAnchor,
                  width: 100,
                  height: 100)
        alreadyButton.anchor(top: stackView.bottomAnchor,
                             paddingTop: 20,
                             centerX: view.centerXAnchor)
        ruleButton.anchor(top: alreadyButton.bottomAnchor,
                          paddingTop: 10,
                          centerX: view.centerXAnchor,
                          width: 100)
    }
    private func setupBinding() {
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.nameTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.nameTextField.layer.borderWidth = 3
                } else {
                    self?.nameTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.nameTextField.layer.borderWidth = 2
                }
                self?.registerBinding.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
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
                self?.registerBinding.emailTextInput.onNext(text ?? "")
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
                self?.registerBinding.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.createUser()
            }
            .disposed(by: disposeBag)
        registerBinding.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? Constants.AppColor.OriginalBlue : .darkGray
            }
            .disposed(by: disposeBag)
        alreadyButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let controller = LoginController.init(nibName: "LoginController", bundle: nil)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
            .disposed(by: disposeBag)
    }
    // MARK: - HelperMethod
    private func createUser() {
        print(#function)
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        AuthService.register(name: name, email: email, password: password) { result, error in
            if result {
                let bool = false
                UserDefaults.standard.set(bool, forKey: "MyId")
                print("Create User Success")
                self.dismiss(animated: true, completion: nil)
            } else {
                if let error = error as NSError? {
                    print("Register Error")
                    self.signUpErrAlert(error)
                }
            }
        }
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
        let charset: Array<Character> =
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
        self.setupCDAlert(title: "登録できません",
                          message: message,
                          action: "OK",
                          alertType: .error)
    }
    // MARK: - SelectorMethod
    @objc private func appleRegister() {
        print(#function)
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
    @objc private func handleRuleButton() {
        print(#function)
        let vc = RuleController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}
// MARK: - GIDSignInDelegate
extension RegisterController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let fullName = user.profile.name
            let email = user.profile.email
            guard let auth = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let id = result?.user.uid else { return }
                    guard let email = email else { return }
                    guard let name = fullName else { return }
                    UserService.setUserData(uid: id, password: "",
                                            email: email,
                                            name: name) { result in
                        if result == true {
                            let bool = false
                            UserDefaults.standard.set(bool, forKey: "MyId")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(error.localizedDescription)
    }
}
// MARK: - UITextFieldDelegate
extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField.tag {
        case 0: emailTextField.becomeFirstResponder()
        case 1: passwordTextField.becomeFirstResponder()
        default: break
        }
        return true
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
                    UserService.setUserData(uid: uid,
                                            password: "",
                                            email: email,
                                            name: name) { result in
                        if result == true {
                            let bool = false
                            UserDefaults.standard.set(bool, forKey: "MyId")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
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
// MARK: - RuleControllerDelegate
extension RegisterController: RuleControllerDelegate {
    func didTapBackButton(_ vc: RuleController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
