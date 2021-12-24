
import UIKit
import RxSwift
import RxCocoa
final class MakeCircleController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let teamBinding = TeamRegisterViewModel()
    @IBOutlet private weak var groupImageView: UIImageView! {
        didSet {
            groupImageView.isUserInteractionEnabled = true
            groupImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var scrollView: UIView!
   
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "サークル登録"
    }

  
    private func setupBinding() {
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




