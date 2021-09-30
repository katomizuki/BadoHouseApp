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
import Firebase

class RegisterViewController:UIViewController{
   
    //Mark :Properties
    private let nameTextField = RegisterTextField(placeholder: "名前")
    private let emailTextField = RegisterTextField(placeholder: "メールアドレス")
    private let passwordTextField = RegisterTextField(placeholder: "パスワード")
    private let registerButton:UIButton = RegisterButton(text: "新規登録")
    private let alreadyButton:UIButton = UIButton(type: .system).createAuthButton(text: "既にアカウントを持っている方はこちらへ")
    private let googlView = GIDSignInButton()
    private var displayName = String()
    private var pictureURL = String()
    private var pictureURLString = String()
    private let iv:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        return iv
    }()
    private let disposeBag = DisposeBag()
    private let registerBinding = RegisterBindings()
    private var IndicatorView:NVActivityIndicatorView!
    private let fbButton = FBLoginButton()
    
    
    
    //Mark :LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBinding()
        googlView.style = .wide
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        fbButton.delegate = self
        //許可するもの
        fbButton.permissions = ["public_profile, email"]
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: Utility.Segue.goWalk, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    

    //Mark: setup Method
    private func setupLayout() {
        //Mark updateUI
        passwordTextField.isSecureTextEntry = true
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        
        //Mark: StackView
        let stackView = UIStackView(arrangedSubviews: [nameTextField,emailTextField,passwordTextField,registerButton,googlView,fbButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        //Mark: addSubView
        view.addSubview(stackView)
        view.addSubview(alreadyButton)
        view.addSubview(iv)
        
        //Mark: Anchor
        nameTextField.anchor(height:45)
        
        stackView.anchor(top:iv.bottomAnchor,
                         left:view.leftAnchor,
                         right:view.rightAnchor,
                         paddingTop:20,
                         paddingRight: 20,
                         paddingLeft: 20,
                         centerX: view.centerXAnchor,height: 400)

        iv.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 30, centerX: view.centerXAnchor,width:100, height:100)
        alreadyButton.anchor(top:stackView.bottomAnchor,paddingTop: 20, centerX: view.centerXAnchor)
        
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
        let startColor = UIColor.white.cgColor
        let endColor = UIColor.darkGray.cgColor
        layer.colors = [startColor,endColor]
        layer.locations = [0.0,1.0]
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
    }
    
    //Mark: Binding
    func setupBinding() {
        
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.nameTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.nameTextField.layer.borderWidth = 3
                } else {
                    self?.nameTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.nameTextField.layer.borderWidth = 1
                }
                self?.registerBinding.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.emailTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.emailTextField.layer.borderWidth = 3
                } else {
                    self?.emailTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.emailTextField.layer.borderWidth = 1
                }
                self?.registerBinding.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text?.count != 0 {
                    self?.passwordTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.passwordTextField.layer.borderWidth = 3
                } else {
                    self?.passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
                    self?.passwordTextField.layer.borderWidth = 1
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
                self.registerButton.backgroundColor = validAll ? Utility.AppColor.StandardColor : .darkGray
            }
            .disposed(by: disposeBag)
        
        alreadyButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let loginVC = self?.storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.LoginVC) as! LoginViewController
                print(loginVC)
                
                self?.navigationController?.pushViewController(loginVC, animated: true)
            }
            .disposed(by: disposeBag)

    }
    
    //Mark:createUser Method
    private func createUser() {
        IndicatorView.startAnimating()
        print(#function)
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.register(name: name, email: email, password: password) { result,error in
            if result {
                self.IndicatorView.stopAnimating()
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
    
    //Mark:signUPErrAlert
    func signUpErrAlert(_ error: NSError){
        if let errCode = AuthErrorCode(rawValue: error.code) {
            var message = ""
            switch errCode {
            case .invalidEmail:      message =  "有効なメールアドレスを入力してください"
            case .emailAlreadyInUse: message = "既に登録されているメールアドレスです"
            case .weakPassword:      message = "パスワードは６文字以上で入力してください"
            default:                 message = "エラー: \(error.localizedDescription)"
            }
            self.showAlert(title: "登録できません", message: message)
        }
    }
    
    
    
    //Mark: AlertMethod
    func showAlert(title: String, message: String?) {
        print(#function)
           let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
           self.present(alertVC, animated: true, completion: nil)
       }
}

extension RegisterViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
                        print("\(error.localizedDescription)")
                    } else {

                        let fullName = user.profile.name

                        let email = user.profile.email
                        //ここで名前とemailとメールアドレスを取得できるのでfirestoreに送る。
                        guard let auth = user.authentication else { return }
                        
                        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
                        Auth.auth().signIn(with: credential) { result, error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Google SignI🌅")
                                guard let id = result?.user.uid else { return }
                                guard let email = email else { return }
                                guard let name = fullName else { return }
                                Firestore.setUserData(uid: id, password: "", email: email, name: name) { result in
                                    if result == true {
                                        let boolArray = [Bool]()
                                        UserDefaults.standard.set(boolArray, forKey: id)
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
    }
    
    //追記部分(デリゲートメソッド)エラー来た時
       func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                 withError error: Error!) {
           print(error.localizedDescription)
       }
}

extension RegisterViewController:LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //loginする
            if error == nil{
                if result?.isCancelled == true{
                    //キャンセルされた場合は何もしないで返す
                    return
                }
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

            //ここからfirebase
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print(error)
                    return
                }
                self.displayName = (result?.user.displayName)!
                //string型に強制変換
                self.pictureURLString = (result?.user.photoURL!.absoluteString)!
                //画像の大きさを変更（大きくした）
                self.pictureURLString = self.pictureURLString + "?type=large"
                guard let name = result?.user.displayName else { return }
                guard let email = result?.user.email else { return }
                guard let id = result?.user.uid else { return }
                Firestore.setUserData(uid: id, password: "", email: email, name: name) { result in
                    if result == true {
                        let boolArray = [Bool]()
                        UserDefaults.standard.set(boolArray, forKey: id)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("logout fb")
    }
}

