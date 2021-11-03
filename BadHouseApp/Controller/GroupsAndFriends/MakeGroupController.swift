import UIKit
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import FirebaseAuth

final class MakeGroupController: UIViewController {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let teamBinding = TeamRegisterBindings()
    var friends = [User]()
    var myData: User?
    @IBOutlet private weak var groupImageView: UIImageView! {
        didSet {
            groupImageView.isUserInteractionEnabled = true
            groupImageView.toCorner(num: 50)
            groupImageView.contentMode = .scaleAspectFill
        }
    }
    private let nameTextField: UITextField = {
        let textField = RegisterTextField(placeholder: "サークル名(必須)")
        textField.tag = 0
        textField.returnKeyType = .next
        textField.keyboardType = .namePhonePad
        textField.backgroundColor = UIColor(named: "TFColor")
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()
    private let placeTextField: UITextField = {
        let textField = RegisterTextField(placeholder: "都道府県選択")
        textField.tag = 1
        textField.returnKeyType = .next
        textField.keyboardType = .namePhonePad
        textField.backgroundColor = UIColor(named: "TFColor")
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()
    private let timeTextField: UITextField = {
        let textField = RegisterTextField(placeholder: "活動曜日選択")
        textField.tag = 2
        textField.returnKeyType = .next
        textField.keyboardType = .namePhonePad
        textField.backgroundColor = UIColor(named: "TFColor")
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()
    private let levelTextField: UITextField = {
        let textField = RegisterTextField(placeholder: "会費 〇〇円/月")
        textField.tag = 3
        textField.returnKeyType = .next
        textField.keyboardType = .numberPad
        textField.backgroundColor = UIColor(named: "TFColor")
        textField.layer.borderColor = UIColor.systemGray.cgColor
        return textField
    }()
    private let plusTextField: UITextField = {
        let textField = RegisterTextField(placeholder: "HPやTwitter,その他情報が乗ったURL(任意)")
        textField.tag = 4
        textField.returnKeyType = .done
        textField.keyboardType = .namePhonePad
        textField.backgroundColor = UIColor(named: "TFColor")
        return textField
    }()
    private let tagLabel = ProfileLabel(title: "特徴タグ")
    private let registerButton: UIButton = {
        let button =  RegisterButton(text: "新規登録")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    private lazy var buttonTag1: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "シングル可")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag2: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "バド好き")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag3: UIButton =  {
        let button = UIButton(type: .system).createTagButton(title: "ミックス可")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag4: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "ダブルス")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag5: UIButton = {
        let button =  UIButton(type: .system).createTagButton(title: "上級者限定")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag6: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "学生限定")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag7: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "初心者歓迎")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag8: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "練習中心")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag9: UIButton = {
        let button =  UIButton(type: .system).createTagButton(title: "子供,学生OK")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag10: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "大会出ます!")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag11: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "土日開催")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var buttonTag12: UIButton = {
        let button = UIButton(type: .system).createTagButton(title: "平日開催")
        button.addTarget(self, action: #selector(tap(sender:)), for: .touchUpInside)
        return button
    }()
    @IBOutlet private weak var scrollView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            scrollView.addGestureRecognizer(gesture)
        }
    }
    private var tagArray = [String]()
    private let fetchData = FetchFirestoreData()
    private let moneyPickerView = UIPickerView()
    private let placePickerView = UIPickerView()
    private let dayPickerView = UIPickerView()
    private let moneyArray = Constants.Data.moneyArray
    private let dayArray = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBinding()
        setupData()
        setupPickerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.title = "サークル登録"
        nameTextField.becomeFirstResponder()
    }
    // MARK: - SetupMethod
    private func setupData() {
        fetchData.myDataDelegate = self
        guard let me = myData else { return }
        let meId = me.uid
        UserService.getFriendData(uid: meId) { [weak self] ids in
            guard let self = self else { return }
            self.fetchData.fetchMyFriendData(idArray: ids)
        }
    }
    private func setupPickerView() {
        setPicker(pickerView: moneyPickerView, textField: levelTextField)
        setPicker(pickerView: placePickerView, textField: placeTextField)
        setPicker(pickerView: dayPickerView, textField: timeTextField)
    }
    private func setPicker(pickerView: UIPickerView, textField: UITextField) {
        pickerView.delegate = self
        textField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0,
                               y: 0,
                               width: self.view.frame.width,
                               height: 44)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                             target: nil,
                                             action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(donePicker))
        toolBar.setItems([flexibleButton, doneButtonItem], animated: true)
        textField.inputAccessoryView = toolBar
    }
    private func setupDelegate() {
        nameTextField.delegate = self
        placeTextField.delegate = self
        timeTextField.delegate = self
        levelTextField.delegate = self
        plusTextField.delegate = self
    }
    private func setupLayout() {
        let basicStackView = UIStackView(arrangedSubviews: [nameTextField,
                                                            placeTextField,
                                                            timeTextField,
                                                            levelTextField,
                                                            plusTextField])
        let buttonStackView = UIStackView(arrangedSubviews: [buttonTag1,
                                                             buttonTag2,
                                                             buttonTag3,
                                                             buttonTag4])
        let buttonStackView2 = UIStackView(arrangedSubviews: [buttonTag5,
                                                              buttonTag6,
                                                              buttonTag7,
                                                              buttonTag8])
        let buttonStackView3 = UIStackView(arrangedSubviews: [buttonTag9,
                                                              buttonTag10,
                                                              buttonTag11,
                                                              buttonTag11,
                                                              buttonTag12])
        helper(stackview: basicStackView, bool: true)
        helper(stackview: buttonStackView, bool: false)
        helper(stackview: buttonStackView2, bool: false)
        helper(stackview: buttonStackView3, bool: false)
        scrollView.addSubview(basicStackView)
        scrollView.addSubview(tagLabel)
        scrollView.addSubview(buttonStackView)
        scrollView.addSubview(buttonStackView2)
        scrollView.addSubview(buttonStackView3)
        scrollView.addSubview(registerButton)
        buttonTag1.anchor(width: 45, height: 45)
        buttonTag5.anchor(width: 45, height: 45)
        buttonTag9.anchor(width: 45, height: 45)
        nameTextField.anchor(height: 45)
        basicStackView.anchor(top: groupImageView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 15,
                              paddingRight: 20,
                              paddingLeft: 20)
        buttonStackView.anchor(top: basicStackView.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               paddingTop: 40,
                               paddingRight: 20,
                               paddingLeft: 20)
        tagLabel.anchor(top: basicStackView.bottomAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 15,
                        paddingRight: 200,
                        paddingLeft: 20)
        buttonStackView2.anchor(top: buttonStackView.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                paddingTop: 15,
                                paddingRight: 20,
                                paddingLeft: 20)
        buttonStackView3.anchor(top: buttonStackView2.bottomAnchor,
                                left: view.leftAnchor,
                                right: view.rightAnchor,
                                paddingTop: 15,
                                paddingRight: 20,
                                paddingLeft: 20)
        registerButton.anchor(top: buttonStackView3.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 15,
                              paddingRight: 20,
                              paddingLeft: 20,
                              height: 45)
    }
    private func setupBinding() {
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.nameTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.nameTextField.layer.borderWidth = 3
                    self?.nameTextField.layer.cornerRadius = 15
                } else {
                    self?.nameTextField.layer.borderColor = UIColor.systemGray.cgColor
                    self?.nameTextField.layer.borderWidth = 2
                }
                self?.teamBinding.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        placeTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.placeTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.placeTextField.layer.borderWidth = 3
                    self?.placeTextField.layer.cornerRadius = 15
                } else {
                    self?.placeTextField.layer.borderColor = UIColor.systemGray.cgColor
                    self?.placeTextField.layer.borderWidth = 2
                }
                self?.teamBinding.placeTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        timeTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.timeTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.timeTextField.layer.borderWidth = 3
                    self?.timeTextField.layer.cornerRadius = 15
                } else {
                    self?.timeTextField.layer.borderColor = UIColor.systemGray.cgColor
                    self?.timeTextField.layer.borderWidth = 2
                }
                self?.teamBinding.timeTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        levelTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.levelTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.levelTextField.layer.borderWidth = 3
                    self?.levelTextField.layer.cornerRadius = 15
                } else {
                    self?.levelTextField.layer.borderColor = UIColor.systemGray.cgColor
                    self?.levelTextField.layer.borderWidth = 2
                }
                self?.teamBinding.levelTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        plusTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                if text != "" {
                    self?.plusTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
                    self?.plusTextField.layer.borderWidth = 3
                    self?.plusTextField.layer.cornerRadius = 15
                } else {
                    self?.plusTextField.layer.borderColor = UIColor.systemGray.cgColor
                    self?.plusTextField.layer.borderWidth = 2
                }
            }
            .disposed(by: disposeBag)
        teamBinding.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? Constants.AppColor.OriginalBlue : .darkGray
            }
            .disposed(by: disposeBag)
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.createTeam()
            }
            .disposed(by: disposeBag)
    }
    // MARK: - selector
    @objc private func donePicker() {
        placeTextField.endEditing(true)
        levelTextField.endEditing(true)
        timeTextField.endEditing(true)
    }
    @objc private func handleTap() {
        print(#function)
        levelTextField.resignFirstResponder()
        placeTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        placeTextField.resignFirstResponder()
        plusTextField.resignFirstResponder()
        timeTextField.resignFirstResponder()
    }
    @objc private func tap(sender: UIButton) {
        if sender.backgroundColor != Constants.AppColor.OriginalBlue {
            sender.backgroundColor = Constants.AppColor.OriginalBlue
            sender.setTitleColor(.white, for: UIControl.State.normal)
        } else {
            sender.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
            sender.setTitleColor(Constants.AppColor.OriginalBlue, for: UIControl.State.normal)
        }
        guard let title = sender.titleLabel?.text else { return }
        if tagArray.contains(title) == false {
            tagArray.append(title)
        } else {
            tagArray.remove(value: title)
        }
    }
    // MARK: - helperMethod
    private func helper(stackview: UIStackView, bool: Bool) {
        stackview.axis = bool == true ? .vertical:.horizontal
        stackview.distribution = .fillEqually
        stackview.spacing = 20
    }
    private func createTeam() {
        print(#function)
        guard let teamName = nameTextField.text else { return }
        guard let teamTime = timeTextField.text else { return }
        if !judgeDate(teamTime) {
            print("not day")
            self.setupCDAlert(title: "適切な曜日を入れてください", message: "", action: "OK", alertType: .warning)
            return
        }
        guard let teamPlace = placeTextField.text else { return }
        guard let teamMoney = changeInt(levelTextField.text) else {
            print("not Int")
            self.setupCDAlert(title: "適切な金額を入れてください", message: "", action: "OK", alertType: .warning)
            return
        }
        if !judgePlace(teamPlace) {
            print("not place")
            self.setupCDAlert(title: "適切な都道府県を入れてください", message: "", action: "OK", alertType: .warning)
            return
        }
        let teamMoneyString = String(teamMoney)
        guard let teamImage = groupImageView.image else { return }
        guard let teamUrl = plusTextField.text else { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.FriendVC) as! InviteToTeamController
        vc.friends = self.friends
        vc.teamName = teamName
        vc.teamTime = teamTime
        vc.teamPlace = teamPlace
        vc.teamImage = teamImage
        vc.teamLevel = teamMoneyString
        vc.me = myData
        vc.url = teamUrl
        vc.teamTagArray = self.tagArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func changeInt(_ target: String?) -> Int? {
        guard let target = target else {
            return nil
        }
        return Int(target)
    }
    private func judgeDate(_ target: String) -> Bool {
        return dayArray.contains(target)
    }
    private func judgePlace(_ target: String) -> Bool {
        return Constants.Data.placeArray.contains(target)
    }
    // MARK: - IBAction
    @IBAction func cameraTap(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
}
// MARK: - UIPickerDelegate,UINavigationControllerDelegate
extension MakeGroupController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            groupImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UIPickerViewDataSource
extension MakeGroupController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.placePickerView {
            return Place.allCases.count
        } else if pickerView == self.dayPickerView {
            return dayArray.count
        } else {
            return moneyArray.count
        }
    }
}
// MARK: - UIPickerViewDelegate
extension MakeGroupController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.placePickerView {
            guard let text = Place(rawValue: row)?.name else { return }
            placeTextField.text = text
        } else if pickerView == self.dayPickerView {
            timeTextField.text = dayArray[row]
        } else {
            levelTextField.text = moneyArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.placePickerView {
            guard let text = Place(rawValue: row)?.name else { return nil }
            return text
        } else if pickerView == self.dayPickerView {
            return dayArray[row]
        } else {
            return moneyArray[row]
        }
    }
}
// MARK: - getFriendDelegate
extension MakeGroupController: FetchMyDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.friends = friendArray
    }
}
// MARK: - uitextFieldDelegate
extension MakeGroupController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            placeTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            timeTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            levelTextField.becomeFirstResponder()
        } else if textField.tag == 3 {
            plusTextField.becomeFirstResponder()
        }
        return true
    }
}
