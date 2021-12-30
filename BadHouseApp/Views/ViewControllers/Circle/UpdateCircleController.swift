//
//  UpdateCircleController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/30.
//

import UIKit
import RxSwift
import PKHUD
protocol UpdateCircleControllerDelegate:AnyObject {
    func pop(_ vc:UpdateCircleController)
}
class UpdateCircleController: UIViewController {
    
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
    var viewModel: UpdateCircleViewModel!
    var coordinator: UpdateCircleCoordinator?
    private var imageSelection: ImageSelection?
    private let imagePicker = UIImagePickerController()
    private lazy var buttons = [singleButton, doubleButton, mixButton,  weekDayButton, weekEndButton, practiceButton, matchButton, genderButton, ageButton]
    private let disposeBag = DisposeBag()
    weak var delegate: UpdateCircleControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupBinding()
        setupImagePicker()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapRightButton))
    }
    
    private func setupUI() {
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
            self?.viewModel.nameTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        moneyTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.viewModel.priceTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        placeTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.viewModel.placeTextInputs.onNext(text)
        }).disposed(by: disposeBag)
        
        dateTextField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.viewModel.dateTextInput.onNext(text)
        }).disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
            self?.viewModel.textViewInputs.onNext(text)
        }).disposed(by: disposeBag)

        
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
        
        practiceButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.practiceButton.backgroundColor = self?.practiceButton.backgroundColor == .lightGray ? .systemBlue : .lightGray
                self?.viewModel.addFeatures(.practiceMain)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.isError.subscribe { [weak self] _ in
            self?.showCDAlert(title: "通信エラーです", message: "", action: "OK", alertType: .warning)
        }.disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe { [weak self] _ in
            self?.popAnimation()
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
            case .none:print("失敗")
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    private func popAnimation() {
        HUD.show(.success, onView: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
