import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol AdditionalEventTitleFlow {
    func toNext(title: String, image: UIImage, kind: String)
}

final class AdditionalEventTitleController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var circleSegment: UISegmentedControl! {
        didSet {
            circleSegment.addTarget(self, action: #selector(segmentTap(sender:)), for: UIControl.Event.valueChanged)
        }
    }
    @IBOutlet private weak var noImageView: UIImageView!
    @IBOutlet private weak var notTitleLabel: UILabel!
    private let disposeBag = DisposeBag()
    private var selectedTeam: Circle?
    private var eventTitle = String()
    private var kindCircle = BadmintonCircle(rawValue: 0)?.name
    private var team: Circle?
    private let pickerView = UIImagePickerController()
    private let viewModel = MakeEventFirstViewModel()
    var coordinator: AdditionalEventTitleFlow?
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(didTapNextButton))
        return button
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        pickerView.delegate = self
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "1/4"
    }

    private func setupBinding() {
        titleTextField.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel.inputs.titleTextInputs.onNext(text ?? "")
        }).disposed(by: disposeBag)

        noImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self]_ in
                guard let self = self else { return }
                self.present(self.pickerView, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        viewModel.outputs.isButtonValid.subscribe(onNext: {[weak self] isValid in
            self?.rightButton.isEnabled = isValid
        }).disposed(by: disposeBag)
    }
    
    // MARK: - SelectorMethod
    @objc private func segmentTap(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        kindCircle = BadmintonCircle(rawValue: index)!.name
        viewModel.practiceKind = kindCircle ?? "社会人サークル"
    }
    @objc private func didTapNextButton() {
        guard let title = self.viewModel.title else { return }
        self.coordinator?.toNext(title: title, image: self.viewModel.practiceImage, kind: self.viewModel.practiceKind)
    }
}

// MARK: - UInavigationDelegate
extension AdditionalEventTitleController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            noImageView.image = image.withRenderingMode(.alwaysOriginal)
            viewModel.inputs.hasImage.accept(true)
            viewModel.practiceImage = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
