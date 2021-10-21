import Foundation
import UIKit
import FirebaseAuth
import RxSwift
import NVActivityIndicatorView
import RxCocoa
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import AuthenticationServices

class RegisterViewController: UIViewController {
    // Mark Properties
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
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
    private let registerBinding = RegisterBindings()
    private var indicatorView: NVActivityIndicatorView!
    private let fbButton = FBLoginButton()
    private lazy var appleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleRegister), for: .touchUpInside)
        return button
    }()
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        setupDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // UserDefaultで条件分岐をする
        if UserDefaults.standard.object(forKey: "MyId") == nil && Auth.auth().currentUser == nil {
            let vc = WalkThroughController()
            present(vc, animated: true, completion: nil)
        }
        navigationController?.isNavigationBarHidden = true
    }
    // Mark setup Method
    private func setupDelegate() {
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        fbButton.delegate = self
        fbButton.permissions = ["public_profile, email"]
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
                                                       fbButton,
                                                       appleButton
                                                       ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        view.addSubview(stackView)
        view.addSubview(alreadyButton)
        view.addSubview(iv)
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
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
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
                let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.LoginVC) as! LoginViewController
                self?.navigationController?.pushViewController(loginVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    // Mark Helper Method
    private func createUser() {
        indicatorView.startAnimating()
        print(#function)
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        AuthService.register(name: name, email: email, password: password) { result, error in
            if result {
                self.indicatorView.stopAnimating()
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
    // Mark signUPErrAlert
    func signUpErrAlert(_ error: NSError) {
        let message = setupErrorMessage(error: error)
        self.setupCDAlert(title: "登録できません",
                          message: message,
                          action: "OK",
                          alertType: .error)
        indicatorView.stopAnimating()
    }
    // Mark selector
    @objc private func appleRegister() {
        print(#function)
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.performRequests()
    }
}
// Mark GoogleSigninDelegate
extension RegisterViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
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
                    UserService.setUserData(uid: id, password: "", email: email, name: name) { result in
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
// Mark FaceBookDelegate
extension RegisterViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil {
            if result?.isCancelled == true {
                return
            }
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error)
                return
            }
            self.displayName = (result?.user.displayName)!
            guard let name = result?.user.displayName else { return }
            guard let email = result?.user.email else { return }
            guard let id = result?.user.uid else { return }
            UserService.setUserData(uid: id, password: "", email: email, name: name) { result in
                if result == true {
                    let bool = false
                    UserDefaults.standard.set(bool, forKey: "MyId")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout fb")
    }
}
// Mark uitextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let tag = textField.tag
        if tag == 0 {
            emailTextField.becomeFirstResponder()
        } else if tag == 1 {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
// Mark AppleRegister Delegate
extension RegisterViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            
            let userId = credential.user
            guard let fullname = credential.fullName else { return }
            guard let email = credential.email else { return }
            guard let givenname = fullname.givenName else { return }
            guard let familyname = fullname.familyName  else { return }
            let name = givenname + familyname
            UserService.setUserData(uid: userId,
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
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
