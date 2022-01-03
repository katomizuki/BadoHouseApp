import UIKit
import RxSwift
import RxCocoa
protocol AddtionalPracticeElementFlow {
    func toNext(image: UIImage,
                circle: Circle,
                user: User,
                dic: [String: Any])
    func toAddtionalPlace()
}
final class AdditionalEventElementController: UIViewController {

    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var courtCountLabel: UILabel!
    @IBOutlet private weak var gatherCountLabel: UILabel!
    @IBOutlet private weak var startDatePicker: UIDatePicker! {
        didSet {
            startDatePicker.addTarget(self, action: #selector(didTapStartPicker), for: .valueChanged)
        }
    }
    @IBOutlet private weak var finishDatePicker: UIDatePicker! {
        didSet {
            finishDatePicker.addTarget(self, action: #selector(didTapFinishButton), for: .valueChanged)
        }
    }
    @IBOutlet private weak var deadLinePicker: UIDatePicker! {
        didSet {
            deadLinePicker.addTarget(self, action: #selector(didTapLinePicker), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var addressNameLabel: UILabel!
    @IBOutlet private weak var placeButton: UIButton!
    private let moneyPicker = UIPickerView()
    private let disposeBag = DisposeBag()
    var coordinator: AddtionalPracticeElementFlow?
    var viewModel: MakeEventThirdViewModel!
    private lazy var rightButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title:"次へ",style:.done, target: self, action: #selector(didTapNextButton))
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setPicker(pickerView: moneyPicker, textField: moneyTextField)
        navigationItem.title = "3/4"
        navigationItem.rightBarButtonItem = rightButton
    }
    private func setupBinding() {
        
        placeButton.rx.tap.asDriver().drive(onNext: { [weak self] _  in
            guard let self = self else { return }
            self.coordinator?.toAddtionalPlace()
        }).disposed(by: disposeBag)
    }
    @IBAction private func courtStepper(_ sender: UIStepper) {
        courtCountLabel.text =  String(Int(sender.value))
        viewModel.inputs.changedCourtCount(Int(sender.value))
    }
    @IBAction private func gatherStepper(_ sender: UIStepper) {
        gatherCountLabel.text = String(Int(sender.value))
        viewModel.inputs.changedGatherCount(Int(sender.value))
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
    @objc private func donePicker() {
        moneyTextField.endEditing(true)
    }
    @objc private func didTapStartPicker(sender: UIDatePicker) {
        viewModel.inputs.changedStartPicker(sender.date)
    }
    @objc private func didTapFinishButton(sender: UIDatePicker) {
        viewModel.inputs.changedFinishPicker(sender.date)
    }
    @objc private func didTapLinePicker(sender :UIDatePicker) {
        viewModel.inputs.changedDeadLinePicker(sender.date)
    }
    @objc private func didTapNextButton() {
        guard let text = self.moneyTextField.text else { return }
        var dic = self.viewModel.dic
        dic["price"] = text
        self.coordinator?.toNext(image: self.viewModel.image,
                                 circle: self.viewModel.circle,
                                 user: self.viewModel.user,
                                 dic: dic)
    }
    
}
// MARK: - UIPickerViewDelegate
extension AdditionalEventElementController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        moneyTextField.text = Constants.Data.moneyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.Data.moneyArray[row]
    }
}
// MARK: - UIPickerViewDataSource
extension AdditionalEventElementController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.Data.moneyArray.count
    }
}
extension AdditionalEventElementController: AddtionalPlaceControllerDelegate {
    func AddtionalPlaceController(vc: AddtionalPlaceController, placeName: String, addressName: String, latitude: Double, longitude: Double) {
        vc.dismiss(animated: true)
//        addressNameLabel.text = addressName
        placeNameLabel.text = placeName
        viewModel.inputs.placeInfo(placeName, addressName, latitude, longitude)
    }
}
