import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import NVActivityIndicatorView
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin

class LoginViewController:UIViewController {
    //Mark :Properties
    private let disposeBag = DisposeBag()
    private let loginBinding = LoginBindings()
    private var IndicatorView:NVActivityIndicatorView!
    private let fbButton = FBLoginButton()
    private let googleView:GIDSignInButton = {
        let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    private let iv:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
        return iv
    }()
    private let emailTextField:UITextField = {
        let tf = RegisterTextField(placeholder: "メールアドレス")
        tf.tag = 0
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        return tf
    }()
    private let passwordTextField:UITextField = {
        let tf = RegisterTextField(placeholder: "パスワード")
        tf.tag = 1
        tf.returnKeyType = .done
        tf.keyboardType = .default
        tf.isSecureTextEntry = true
        return tf
    }()
    private let loginButton:UIButton = {
        let button = RegisterButton(text: "ログイン")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return button
    }()
    private let dontHaveButton = UIButton(type: .system).createAuthButton(text: "新規登録の方はこちらへ")
    //Mark: LifeCycle
    override func viewDidLoad() {
        setupLayout()
        setupBinding()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    //Mark: SetupMethod
    private func setupLayout(){
        let basicStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,googleView,fbButton])
        basicStackView.axis = .vertical
        basicStackView.distribution = .fillEqually
        basicStackView.spacing = 20
        
        view.addSubview(basicStackView)
        view.addSubview(iv)
        view.addSubview(dontHaveButton)
        
        emailTextField.anchor(height:45)
        basicStackView.anchor(top:iv.bottomAnchor,left:view.leftAnchor, right:view.rightAnchor,paddingTop:20, paddingRight: 20, paddingLeft: 20,height: 330)
        iv.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 30, centerX: view.centerXAnchor,width:100, height:100)
        dontHaveButton.anchor(top:basicStackView.bottomAnchor,paddingTop: 20, centerX: view.centerXAnchor)
        
        dontHaveButton.addTarget(self, action: #selector(moveAlready), for: UIControl.Event.touchUpInside)
        
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        fbButton.delegate = self
        fbButton.permissions = ["public_profile, email"]
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
                    self?.emailTextField.layer.borderWidth = 1
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
                    self?.passwordTextField.layer.borderWidth = 1
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
    //Mark :selector
    @objc func moveAlready() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    //Mark: Login
    private func login() {
        print(#function)
        IndicatorView.stopAnimating()
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        AuthService.loginFirebaseAuth(email: email, password: password) { result,error in
            if result {
                self.IndicatorView.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            } else {
                if let error = error as NSError? {
                    self.signInErrAlert(error)
                }
            }
        }
    }
    //Mark: LoginError
    private func signInErrAlert(_ error: NSError){
        print(#function)
        let message = setupErrorMessage(error: error)
        self.setupCDAlert(title: "ログインできませんでした", message: message, action: "OK", alertType: .error)
    }
}
//Mark GoogleSigninDelegate
extension LoginViewController:GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            guard let auth = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credential) { result, error in
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
//Mark facebookDelegate
extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout fb")
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil{
            if result?.isCancelled == true{
                return
            }
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error)
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
//Mark textFieldDelegate
extension LoginViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
