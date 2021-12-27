
import UIKit
import RxSwift
import RxCocoa
import RxGesture
protocol MakeCircleFlow {
    func toInvite()
    func pop()
}
final class MakeCircleController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel = TeamRegisterViewModel()
    private let imagePicker = UIImagePickerController()
    var coordinator: MakeCircleFlow?
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
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var singleButton: UIButton!
    @IBOutlet private weak var doubleButton: UIButton!
    @IBOutlet private weak var mixButton: UIButton!
    @IBOutlet private weak var practiceMainButton: UIButton!
    @IBOutlet private weak var weekEndButton: UIButton!
    @IBOutlet private weak var weekDayButton: UIButton!
    @IBOutlet private weak var matchButton: UIButton!
    @IBOutlet private weak var genderButton: UIButton!
    @IBOutlet private weak var ageButton: UIButton!
    @IBOutlet private weak var circleNameTextField: UITextField!
    @IBOutlet private weak var priceNameTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var placeNameTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.tintColor = .systemBlue
    }

    private func setupBinding() {
        groupImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)
        
        backGroundImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)
        
        makeCircleButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.createTeam()
        }).disposed(by: disposeBag)
        
        inviteFriendButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.coordinator?.toInvite()
                print("sasasagag")
        }).disposed(by: disposeBag)
        
        circleNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.nameTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        placeNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.placeTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        dateTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.timeTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        priceNameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.priceTextInput.onNext(text ?? "")
            }.disposed(by: disposeBag)
        
        viewModel.validRegisterDriver
            .drive { [weak self] validAll in
                self?.registerButton.isEnabled = validAll
                self?.registerButton.backgroundColor = validAll ? .lightGray : .systemBlue
            }.disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.createTeam()
                self?.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        singleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.singleButton.backgroundColor = self?.viewModel.buttonColor(color: self?.singleButton.backgroundColor)
            self?.viewModel.addFeatures(.single)
        }.disposed(by: disposeBag)
        
        doubleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.doubleButton.backgroundColor = self?.viewModel.buttonColor(color: self?.doubleButton.backgroundColor)
                self?.viewModel.addFeatures(.double)
        }.disposed(by: disposeBag)
        
        mixButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.mixButton.backgroundColor = self?.viewModel.buttonColor(color: self?.mixButton.backgroundColor)
            self?.viewModel.addFeatures(.mix)
        }.disposed(by: disposeBag)
        
        weekDayButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.weekDayButton.backgroundColor = self?.viewModel.buttonColor(color: self?.weekDayButton.backgroundColor)
            self?.viewModel.addFeatures(.weekDay)
        }.disposed(by: disposeBag)
        
        weekEndButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.weekEndButton.backgroundColor = self?.viewModel.buttonColor(color: self?.weekEndButton.backgroundColor)
                self?.viewModel.addFeatures(.weekEnd)
            }.disposed(by: disposeBag)
        
        ageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.ageButton.backgroundColor = self?.viewModel.buttonColor(color: self?.ageButton.backgroundColor)
                self?.viewModel.addFeatures(.notAge)
            }.disposed(by: disposeBag)
        
        genderButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.genderButton.backgroundColor = self?.viewModel.buttonColor(color: self?.genderButton.backgroundColor)
                self?.viewModel.addFeatures(.notGender)
            }.disposed(by: disposeBag)
        
        matchButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.matchButton.backgroundColor = self?.viewModel.buttonColor(color: self?.matchButton.backgroundColor)
                self?.viewModel.addFeatures(.gameMain)
            }.disposed(by: disposeBag)
        
        practiceMainButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.practiceMainButton.backgroundColor = self?.viewModel.buttonColor(color: self?.practiceMainButton.backgroundColor)
                self?.viewModel.addFeatures(.practiceMain)
            }.disposed(by: disposeBag)


    }

    private func createTeam() {

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




