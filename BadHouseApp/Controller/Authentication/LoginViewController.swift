

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase
import NVActivityIndicatorView


class LoginViewController:UIViewController {
    
    private let disposeBag = DisposeBag()
    private let loginBinding = LoginBindings()
    private var IndicatorView:NVActivityIndicatorView!
    
    //Mark :Properties
    private let titleLabel = RegisterTitleLabel(text: "バドハウス")
    private let emailTextField = RegisterTextField(placeholder: "メールアドレス")
    private let passwordTextField = RegisterTextField(placeholder: "パスワード")
    private let loginButton:UIButton = RegisterButton(text: "ログイン")
    private let dontHaveButton = UIButton(type: .system).createAuthButton(text: "新規登録の方はこちらへ")
    
    //Mark: LifeCycle
    override func viewDidLoad() {
        setupGradient()
        setupLayout()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    //Mark: Setup
    private func setupLayout(){
        //Mark:UpdateUI
        passwordTextField.isSecureTextEntry = true
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
       
        
        //Mark:StackView
        let basicStackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        basicStackView.axis = .vertical
        basicStackView.distribution = .fillEqually
        basicStackView.spacing = 20
        
        //Mark:addSubView
        view.addSubview(basicStackView)
        view.addSubview(titleLabel)
        view.addSubview(dontHaveButton)
        
        //Mark:Anchor
        emailTextField.anchor(height:45)
        basicStackView.anchor(left:view.leftAnchor, right:view.rightAnchor, paddingRight: 20, paddingLeft: 20, centerY: view.centerYAnchor)
        titleLabel.anchor(bottom:basicStackView.topAnchor,paddingBottom: 20, centerX: view.centerXAnchor)
        dontHaveButton.anchor(top:basicStackView.bottomAnchor,paddingTop: 20, centerX: view.centerXAnchor)
        
        
        //Mark:addTarget
        dontHaveButton.addTarget(self, action: #selector(moveAlready), for: UIControl.Event.touchUpInside)
        
        //Mark:NVActivityIndicatorView
        IndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width / 2,
                                                              y: view.frame.height / 2,
                                                              width: 60,
                                                              height: 60),
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
    }
    
    //Mark:Gradient
    private func setupGradient() {
        let layer = CAGradientLayer()
        let startColor = Utility.AppColor.StandardColor.cgColor
        let endColor = Utility.AppColor.OriginalBlue.cgColor
        layer.colors = [startColor,endColor]
        layer.locations = [0.0,1.0]
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
    }
    
    //Mark:Binding
    private func setupBinding() {
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.loginBinding.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
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
                self.loginButton.backgroundColor = validAll ? Utility.AppColor.StandardColor : .darkGray
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
        Auth.loginFirebaseAuth(email: email, password: password) { result,error in
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
        if let errCode = AuthErrorCode(rawValue: error.code) {
            var message = ""
            switch errCode {
            case .userNotFound:  message = "アカウントが見つかりませんでした"
            case .wrongPassword: message = "パスワードを確認してください"
            case .userDisabled:  message = "アカウントが無効になっています"
            case .invalidEmail:  message = "Eメールが無効な形式です"
            default:             message = "エラー: \(error.localizedDescription)"
            }
            self.showAlert(title: "ログインできませんでした", message: message)
        }
    }
    
    //Mark: AlertMethod
    private func showAlert(title: String, message: String?) {
        print(#function)
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
}
