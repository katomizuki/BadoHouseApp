import UIKit
import RxSwift

protocol UpdateCircleControllerDelegate: AnyObject {
    func pop(_ vc: UpdateCircleController)
}

final class UpdateCircleController: UIViewController {
    
    @IBOutlet private weak var backGroundImage: UIImageView!
    @IBOutlet private weak var iconImage: UIImageView! {
        didSet { iconImage.changeCorner(num: 30) }
    }
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var placeTextField: UITextField!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var singleButton: UIButton!
    @IBOutlet private weak var doubleButton: UIButton!
    @IBOutlet private weak var mixButton: UIButton!
    @IBOutlet private weak var weekDayButton: UIButton!
    @IBOutlet private weak var weekEndButton: UIButton!
    @IBOutlet private weak var practiceButton: UIButton!
    @IBOutlet private weak var genderButton: UIButton!
    @IBOutlet private weak var matchButton: UIButton!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var ageButton: UIButton!

    private let viewModel: UpdateCircleViewModel
    private let imagePicker = UIImagePickerController()
    private let disposeBag = DisposeBag()
    private var imageSelection: ImageSelection?
    private lazy var buttons = [singleButton, doubleButton, mixButton, weekDayButton, weekEndButton, practiceButton, matchButton, genderButton, ageButton]
    
    var coordinator: UpdateCircleCoordinator?
    weak var delegate: UpdateCircleControllerDelegate?
    
    init(viewModel: UpdateCircleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear.accept(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.willDisAppear.accept(())
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapRightButton))
    }
    
    private func setupViewData() {
        nameTextField.text = viewModel.circle.name
        backGroundImage.sd_setImage(with: viewModel.circle.backGroundUrl)
        iconImage.sd_setImage(with: viewModel.circle.iconUrl)
        placeTextField.text = viewModel.circle.place
        dateTextField.text = viewModel.circle.time
        textView.text = viewModel.circle.additionlText
        moneyTextField.text = viewModel.circle.price
        buttons.forEach { button in
            guard let title = button?.currentTitle else { return }
            if viewModel.circle.features.contains(title) {
                button?.backgroundColor = .systemBlue
            } else {
                button?.backgroundColor = .lightGray
            }
        }
    }
    
    private func setupUI() {
        setupViewData()
        setupImagePicker()
        setupNavigationBar()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
    }
    
    private func setupBinding() {
        
        iconImage.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.imageSelection = .icon
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)
        
        backGroundImage.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.imageSelection = .backGround
                self.present(self.imagePicker, animated: true)
            }).disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.nameTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        moneyTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.priceTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        placeTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.placeTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        dateTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.dateTextInput.onNext(text)
        }).disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            self.viewModel.textViewInputs.onNext(text)
        }).disposed(by: disposeBag)

        singleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.singleButton.backgroundColor = self.singleButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self.viewModel.addFeatures(.single)
        }.disposed(by: disposeBag)
        
        doubleButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.doubleButton.backgroundColor = self.doubleButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.double)
        }.disposed(by: disposeBag)

        mixButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.mixButton.backgroundColor = self.mixButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self.viewModel.addFeatures(.mix)
        }.disposed(by: disposeBag)
        
        weekDayButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.weekDayButton.backgroundColor = self.weekDayButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
            self.viewModel.addFeatures(.weekDay)
        }.disposed(by: disposeBag)
        
        weekEndButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.weekEndButton.backgroundColor = self.weekEndButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.weekEnd)
            }.disposed(by: disposeBag)
        
        ageButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.ageButton.backgroundColor = self.ageButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.notAge)
            }.disposed(by: disposeBag)
        
        genderButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.genderButton.backgroundColor = self.genderButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.notGender)
            }.disposed(by: disposeBag)
        
        matchButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.matchButton.backgroundColor = self.matchButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.gameMain)
            }.disposed(by: disposeBag)
        
        practiceButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                self.practiceButton.backgroundColor = self.practiceButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self.viewModel.addFeatures(.practiceMain)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.showAlert(title: R.alertMessage.netError,
                             message: "",
                             action: R.alertMessage.ok)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.popAnimation()
        }.disposed(by: disposeBag)
    }
    
    @objc private func didTapRightButton() {
        viewModel.inputs.save()
    }
}

extension UpdateCircleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            switch imageSelection {
            case .backGround:
                backGroundImage.image = image.withRenderingMode(.alwaysOriginal)
                viewModel.backgroundImage = image.withRenderingMode(.alwaysOriginal)
            case .icon:
                iconImage.image = image.withRenderingMode(.alwaysOriginal)
                viewModel.iconImage = image.withRenderingMode(.alwaysOriginal)
            case .none:print("")
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }

    private func popAnimation() {
        // TODO: - 何かしらのFBが欲しいかも
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
