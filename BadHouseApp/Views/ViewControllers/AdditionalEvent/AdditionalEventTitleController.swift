//
//  AdditionalEventTitleController.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
class AdditionalEventTitleController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var circleSegment: UISegmentedControl! {
        didSet {
            circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
        }
    }
    @IBOutlet private weak var noImageView: UIImageView!
    @IBOutlet private weak var notTitleLabel: UILabel!
    private let disposeBag = DisposeBag()
    private var selectedTeam: TeamModel?
    private var eventTitle = String()
    private var kindCircle = BadmintonCircle(rawValue: 0)?.name
    private var team: TeamModel?
    private let pickerView = UIImagePickerController()
    private let viewModel = MakeEventFirstViewModel()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        pickerView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }

    private func setupBinding() {
        titleTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.titleTextInputs.onNext(text ?? "")
        }).disposed(by: disposeBag)

        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            let controller = AddtionalEventLevelController.init(nibName: "AddtionalEventLevelController", bundle: nil)
            self?.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)

        noImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self]_ in
                guard let self = self else { return }
                self.present(self.pickerView, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        viewModel.outputs.isButtonValid.subscribe(onNext: {[weak self] isValid in
            self?.nextButton.isEnabled = isValid
            self?.nextButton.backgroundColor = self?.viewModel.outputs.buttonColor
            self?.nextButton.setTitleColor(self?.viewModel.outputs.buttonTextColor, for: .normal)
        }).disposed(by: disposeBag)
    }
    // MARK: - SelectorMethod
    @objc private func segmentTap(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        kindCircle = BadmintonCircle(rawValue: index)?.name
    }
}
// MARK: - UInavigationDelegate
extension AdditionalEventTitleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            noImageView.image = image.withRenderingMode(.alwaysOriginal)
            viewModel.inputs.hasImage.accept(true)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
