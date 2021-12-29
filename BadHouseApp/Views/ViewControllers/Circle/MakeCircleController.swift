
import UIKit
import RxSwift
import RxCocoa
import RxGesture
protocol MakeCircleFlow {
    func toInvite(_ user: User,form: Form?)
    func pop()
}
enum ImageSelection {
    case backGround
    case icon
}
final class MakeCircleController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var viewModel:TeamRegisterViewModel!
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
    private var imageSelection: ImageSelection?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupImagePicker()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarItem()
    }
    private func setupNavigationBarItem() {
        navigationController?.toolbar.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "友だちを招待して作成", style: .done, target: self, action: #selector(didTapMakeCircleButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    private func setupImagePicker() {
        imagePicker.delegate = self
    }
    private func setupBinding() {
        groupImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.imageSelection = .icon
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)
        
        backGroundImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.imageSelection = .backGround
                self.present(self.imagePicker, animated: true)
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
                self?.navigationItem.rightBarButtonItem?.isEnabled = validAll
            }.disposed(by: disposeBag)
        
        singleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.singleButton.backgroundColor = self?.singleButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self?.viewModel.addFeatures(.single)
        }.disposed(by: disposeBag)
        
        doubleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.doubleButton.backgroundColor = self?.doubleButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.double)
        }.disposed(by: disposeBag)

        mixButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.mixButton.backgroundColor = self?.mixButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self?.viewModel.addFeatures(.mix)
        }.disposed(by: disposeBag)
        
        weekDayButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.weekDayButton.backgroundColor = self?.weekDayButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self?.viewModel.addFeatures(.weekDay)
        }.disposed(by: disposeBag)
        
        weekEndButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.weekEndButton.backgroundColor = self?.weekEndButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.weekEnd)
            }.disposed(by: disposeBag)
        
        ageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.ageButton.backgroundColor = self?.ageButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.notAge)
            }.disposed(by: disposeBag)
        
        genderButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.genderButton.backgroundColor = self?.genderButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.notGender)
            }.disposed(by: disposeBag)
        
        matchButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.matchButton.backgroundColor = self?.matchButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.gameMain)
            }.disposed(by: disposeBag)
        
        practiceMainButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.practiceMainButton.backgroundColor = self?.practiceMainButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.practiceMain)
            }.disposed(by: disposeBag)
        
        detailTextView.rx.text.orEmpty.subscribe(onNext: { text in
            self.viewModel.textViewInput.onNext(text)
        }).disposed(by: disposeBag)


    }
    @objc private func didTapMakeCircleButton() {
        coordinator?.toInvite(viewModel.user, form: viewModel.form)
    }
}
// MARK: - UIPickerDelegate,UINavigationControllerDelegate
extension MakeCircleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            switch imageSelection {
            case .backGround:
                backGroundImageView.image = image.withRenderingMode(.alwaysOriginal)
                viewModel.form.background = image.withRenderingMode(.alwaysOriginal)
            case .icon:
                groupImageView.image = image.withRenderingMode(.alwaysOriginal)
                viewModel.form.icon = image.withRenderingMode(.alwaysOriginal)
            case .none:print("失敗")
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
