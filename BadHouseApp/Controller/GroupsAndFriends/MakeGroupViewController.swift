import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import FirebaseAuth

class MakeGroupViewController: UIViewController,UIImagePickerControllerDelegate {
    
    //Mark :Properties
    private let disposeBag = DisposeBag()
    private let teamBinding = TeamRegisterBindings()
    var friends = [User]()
    var me:User?
    @IBOutlet weak var groupImageView: UIImageView!
    private let nameTextField = RegisterTextField(placeholder: "サークル名(必須)")
    private let placeTextField = RegisterTextField(placeholder: "主な活動場所 〇〇スポーツセンター,不定等")
    private let timeTextField = RegisterTextField(placeholder: "主な活動時間 毎週〇〇曜日○時から,不定期等")
    private let levelTextField = RegisterTextField(placeholder: "会費 〇〇円/月 シャトル代により変動等")
    private let plusTextField = RegisterTextField(placeholder: "HPやTwitter,その他情報が乗ったURL(任意)")
    private let tagLabel = ProfileLabel(title: "特徴タグ")
    private let registerButton:UIButton = RegisterButton(text: "新規登録")
    private let buttonTag1 = UIButton(type: .system).createTagButton(title: "シングル可")
    private let buttonTag2 = UIButton(type: .system).createTagButton(title: "バド好き歓迎")
    private let buttonTag3 = UIButton(type: .system).createTagButton(title: "ミックス可")
    private let buttonTag4 = UIButton(type: .system).createTagButton(title: "ダブルス")
    private let buttonTag5 = UIButton(type: .system).createTagButton(title: "上級者限定")
    private let buttonTag6 = UIButton(type: .system).createTagButton(title: "学生限定")
    private let buttonTag7 = UIButton(type: .system).createTagButton(title: "初心者歓迎")
    private let buttonTag8 = UIButton(type: .system).createTagButton(title: "練習あります")
    private let buttonTag9 = UIButton(type: .system).createTagButton(title: "子供,学生OK")
    private let buttonTag10 = UIButton(type: .system).createTagButton(title: "大会出ます!")
    private let buttonTag11 = UIButton(type: .system).createTagButton(title: "土日開催")
    private let buttonTag12 = UIButton(type: .system).createTagButton(title: "平日開催")
    @IBOutlet weak var scrollView: UIView!
    private var tagArray = [String]()
 
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        guard let me = me else { return }
        Firestore.getFriendData(uid: me.uid) { friendId in
            print(friendId)
            for i in 0..<friendId.count {
                let id = friendId[i]
                Firestore.getUserData(uid: id) { friend in
                    guard let friend = friend else { return }
                    print(friend.name)
                    self.friends.append(friend)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage(named: "double")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
    }
    
    //Mark:setupLayout
    private func setupLayout() {
        
        //Mark: updateUI
        groupImageView.isUserInteractionEnabled = true
        groupImageView.layer.cornerRadius = 50
        groupImageView.layer.masksToBounds = true
        groupImageView.contentMode = .scaleAspectFill
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        //Mark: readyStackView
        let basicStackView = UIStackView(arrangedSubviews: [nameTextField,placeTextField,timeTextField,levelTextField,plusTextField])
        let buttonStackView = UIStackView(arrangedSubviews: [buttonTag1,buttonTag2,buttonTag3,buttonTag4])
        let buttonStackView2 = UIStackView(arrangedSubviews: [buttonTag5,buttonTag6,buttonTag7,buttonTag8])
        let buttonStackView3 = UIStackView(arrangedSubviews: [buttonTag9,buttonTag10,buttonTag11,buttonTag11,buttonTag12])
        
        //Mark: updateStackView
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 5
        buttonStackView.distribution = .fillEqually
        
        buttonStackView2.axis = .horizontal
        buttonStackView2.spacing = 5
        buttonStackView2.distribution = .fillEqually
        
        buttonStackView3.axis = .horizontal
        buttonStackView3.spacing = 5
        buttonStackView3.distribution = .fillEqually
        
        basicStackView.axis = .vertical
        basicStackView.distribution = .fillEqually
        basicStackView.spacing = 20
        
        //Mark:addSubview
        scrollView.addSubview(basicStackView)
        scrollView.addSubview(tagLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(buttonStackView2)
        scrollView.addSubview(buttonStackView3)
        scrollView.addSubview(registerButton)
        
        //Mark:anchor
        buttonTag1.anchor(width: 45, height:45)
        buttonTag5.anchor(width:45, height: 45)
        buttonTag9.anchor(width:45,height: 45)
        nameTextField.anchor(height:45)
        basicStackView.anchor(top:groupImageView.bottomAnchor,
                              left:view.leftAnchor,
                              right:view.rightAnchor,
                              paddingTop: 15,
                              paddingRight: 20,
                              paddingLeft: 20)
        
        buttonStackView.anchor(top: basicStackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingRight: 20, paddingLeft: 20)
        tagLabel.anchor(top: basicStackView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop:15,paddingRight: 200,paddingLeft: 20)
        buttonStackView2.anchor(top:buttonStackView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 15,paddingRight: 20,paddingLeft: 20)
        buttonStackView3.anchor(top: buttonStackView2.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 15,paddingRight: 20,paddingLeft: 20)
        registerButton.anchor(top:buttonStackView3.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 15,paddingRight: 20, paddingLeft: 20,height: 45)
        
        //Mark:selector
        buttonTag1.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag2.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag3.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag4.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag5.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag6.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag7.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag8.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag9.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag10.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag11.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
        buttonTag12.addTarget(self, action: #selector(tap(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    //Mark:selector
    @objc func tap(sender:UIButton) {
        if sender.backgroundColor != Utility.AppColor.OriginalBlue {
            sender.backgroundColor = Utility.AppColor.OriginalBlue
            sender.setTitleColor(.white, for: UIControl.State.normal)
        } else {
            sender.backgroundColor = .white
            sender.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
        }
        guard let title = sender.titleLabel?.text else { return }
        if tagArray.contains(title) == false {
            tagArray.append(title)
        } else {
            tagArray.remove(value: title)
        }
    }
    
    //Mark:setupBiding
    private func setupBinding() {
        
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.nameTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.nameTextField.layer.borderWidth = 4
                    self?.nameTextField.layer.cornerRadius = 15
                } else {
                    self?.nameTextField.layer.borderColor = UIColor.black.cgColor
                    self?.nameTextField.layer.borderWidth = 1
                }
                self?.teamBinding.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        placeTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.placeTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.placeTextField.layer.borderWidth = 4
                    self?.placeTextField.layer.cornerRadius = 15
                } else {
                    self?.placeTextField.layer.borderColor = UIColor.black.cgColor
                    self?.placeTextField.layer.borderWidth = 1
                }
                self?.teamBinding.placeTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        timeTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.timeTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.timeTextField.layer.borderWidth = 4
                    self?.timeTextField.layer.cornerRadius = 15
                } else {
                    self?.timeTextField.layer.borderColor = UIColor.black.cgColor
                    self?.timeTextField.layer.borderWidth = 1
                }
                self?.teamBinding.timeTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        levelTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.levelTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.levelTextField.layer.borderWidth = 4
                    self?.levelTextField.layer.cornerRadius = 15
                } else {
                    self?.levelTextField.layer.borderColor = UIColor.black.cgColor
                    self?.levelTextField.layer.borderWidth = 1
                }
                self?.teamBinding.levelTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        plusTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.plusTextField.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                    self?.plusTextField.layer.borderWidth = 4
                    self?.plusTextField.layer.cornerRadius = 15
                } else {
                    self?.plusTextField.layer.borderColor = UIColor.black.cgColor
                    self?.plusTextField.layer.borderWidth = 1
                }
            }
            .disposed(by: disposeBag)
        
        
        teamBinding.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? Utility.AppColor.OriginalBlue : .darkGray
            }
            .disposed(by: disposeBag)
        
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                //SendTeamData
                self?.createTeam()
            }
            .disposed(by: disposeBag)
    }
    
    //Mark:CreateTeam
    private func createTeam() {
        print(#function)
        
        guard let teamName = nameTextField.text else { return }
        guard let teamTime = timeTextField.text else { return }
        guard let teamPlace = placeTextField.text else { return }
        guard let teamLevel = levelTextField.text else { return }
        guard let teamImage = groupImageView.image else { return }
        guard let teamUrl = plusTextField.text else { return }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendVC") as! FriendsViewController
       
            vc.friends = self.friends
        
        vc.teamName = teamName
        vc.teamTime = teamTime
        vc.teamPlace = teamPlace
        vc.teamImage = teamImage
        vc.teamLevel = teamLevel
        vc.me = me
        vc.url = teamUrl
        vc.teamTagArray = self.tagArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark: IBAction
    @IBAction func cameraTap(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true) {
            print("Camera Start")
        }
    }
}



//Mark UIPickerDelegate,UINavigationControllerDelegate
extension MakeGroupViewController:UIPickerViewDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            groupImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}


