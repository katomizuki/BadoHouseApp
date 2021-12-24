
import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class MakeCircleController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let teamBinding = TeamRegisterViewModel()
    private let imagePicker = UIImagePickerController()
    @IBOutlet private weak var groupImageView: UIImageView! {
        didSet {
            groupImageView.layer.cornerRadius = 30
            groupImageView.layer.masksToBounds = true
            groupImageView.layer.borderWidth = 1
            groupImageView.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var scrollView: UIView!
   
    @IBOutlet private weak var makeCircleButton: UIButton! {
        didSet {
            makeCircleButton.layer.cornerRadius = 8
            makeCircleButton.layer.borderColor = UIColor.systemBlue.cgColor
            makeCircleButton.layer.borderWidth = 1
            makeCircleButton.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var inviteFriendButton: UIButton! {
        didSet {
            inviteFriendButton.layer.cornerRadius = 8
            inviteFriendButton.layer.masksToBounds = true
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.tintColor = .systemBlue
        let rightButton = UIBarButtonItem(title: "サークル作成", style: .done, target: self, action: #selector(didTapNavBarRightButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    @objc private func didTapNavBarRightButton() {
        print(#function)
    }

    private func setupBinding() {
        groupImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)

//        nameTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text != "" {
//                    self?.nameTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.nameTextField.layer.borderWidth = 3
//                    self?.nameTextField.layer.cornerRadius = 15
//                } else {
//                    self?.nameTextField.layer.borderColor = UIColor.systemGray.cgColor
//                    self?.nameTextField.layer.borderWidth = 2
//                }
//                self?.teamBinding.nameTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        placeTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text != "" {
//                    self?.placeTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.placeTextField.layer.borderWidth = 3
//                    self?.placeTextField.layer.cornerRadius = 15
//                } else {
//                    self?.placeTextField.layer.borderColor = UIColor.systemGray.cgColor
//                    self?.placeTextField.layer.borderWidth = 2
//                }
//                self?.teamBinding.placeTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        timeTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text != "" {
//                    self?.timeTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.timeTextField.layer.borderWidth = 3
//                    self?.timeTextField.layer.cornerRadius = 15
//                } else {
//                    self?.timeTextField.layer.borderColor = UIColor.systemGray.cgColor
//                    self?.timeTextField.layer.borderWidth = 2
//                }
//                self?.teamBinding.timeTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        levelTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text != "" {
//                    self?.levelTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.levelTextField.layer.borderWidth = 3
//                    self?.levelTextField.layer.cornerRadius = 15
//                } else {
//                    self?.levelTextField.layer.borderColor = UIColor.systemGray.cgColor
//                    self?.levelTextField.layer.borderWidth = 2
//                }
//                self?.teamBinding.levelTextInput.onNext(text ?? "")
//            }
//            .disposed(by: disposeBag)
//        plusTextField.rx.text
//            .asDriver()
//            .drive { [weak self] text in
//                if text != "" {
//                    self?.plusTextField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
//                    self?.plusTextField.layer.borderWidth = 3
//                    self?.plusTextField.layer.cornerRadius = 15
//                } else {
//                    self?.plusTextField.layer.borderColor = UIColor.systemGray.cgColor
//                    self?.plusTextField.layer.borderWidth = 2
//                }
//            }
//            .disposed(by: disposeBag)
//        teamBinding.validRegisterDriver
//            .drive { validAll in
//                self.registerButton.isEnabled = validAll
//                self.registerButton.backgroundColor = validAll ? Constants.AppColor.OriginalBlue : .darkGray
//            }
//            .disposed(by: disposeBag)
//        registerButton.rx.tap
//            .asDriver()
//            .drive { [weak self] _ in
//                self?.createTeam()
//            }
//            .disposed(by: disposeBag)
    }

   
    private func createTeam() {
        print(#function)
//        guard let teamName = nameTextField.text else { return }
//        guard let teamTime = timeTextField.text else { return }
//        if !judgeDate(teamTime) {
//            print("not day")
//            self.setupCDAlert(title: "適切な曜日を入れてください", message: "", action: "OK", alertType: .warning)
//            return
//        }
//        guard let teamPlace = placeTextField.text else { return }
//        guard let teamMoney = changeInt(levelTextField.text) else {
//            print("not Int")
//            self.setupCDAlert(title: "適切な金額を入れてください", message: "", action: "OK", alertType: .warning)
//            return
//        }
//        if !judgePlace(teamPlace) {
//            print("not place")
//            self.setupCDAlert(title: "適切な都道府県を入れてください", message: "", action: "OK", alertType: .warning)
//            return
//        }
//        let teamMoneyString = String(teamMoney)
//        guard let teamImage = groupImageView.image else { return }
//        guard let teamUrl = plusTextField.text else { return }
//        let controller = InviteToCircleController.init(nibName: "InviteToCircleController", bundle: nil)
//        controller.friends = self.friends
//        controller.teamName = teamName
//        controller.teamTime = teamTime
//        controller.teamPlace = teamPlace
//        controller.teamImage = teamImage
//        controller.teamLevel = teamMoneyString
//        controller.me = myData
//        controller.url = teamUrl
//        controller.teamTagArray = self.tagArray
//        self.navigationController?.pushViewController(controller, animated: true)
    }
//    private func changeInt(_ target: String?) -> Int? {
//        guard let target = target else {
//            return nil
//        }
//        return Int(target)
//    }
//    private func judgeDate(_ target: String) -> Bool {
//        return dayArray.contains(target)
//    }
//    private func judgePlace(_ target: String) -> Bool {
//        return Place.placeArray.contains(target)
//    }
    // MARK: - IBAction
    @IBAction func cameraTap(_ sender: Any) {
        print(#function)
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        self.present(pickerView, animated: true)
    }
}
// MARK: - UIPickerDelegate,UINavigationControllerDelegate
extension MakeCircleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(#function)
        if let image = info[.originalImage] as? UIImage {
            groupImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        self.dismiss(animated: true, completion: nil)
    }
}




