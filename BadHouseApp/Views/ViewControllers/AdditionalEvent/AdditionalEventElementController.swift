import UIKit
import RxSwift
import RxCocoa

final class AdditionalEventElementController: UIViewController {

    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var courtCountLabel: UILabel!
    @IBOutlet private weak var gatherCountLabel: UILabel!
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var finishDatePicker: UIDatePicker!
    @IBOutlet private weak var deadLinePicker: UIDatePicker!
    @IBOutlet private weak var placeButton: UIButton!
    private let moneyPicker = UIPickerView()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupNavAccessory()
        setPicker(pickerView: moneyPicker, textField: moneyTextField)
    }
    private func setupBinding() {
        nextButton.rx.tap.asDriver().drive(onNext: { [weak self] _  in
            guard let self = self else { return }
            let controller = EventAdditionlItemsController.init(nibName: "EventAdditionlItemsController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
        placeButton.rx.tap.asDriver().drive(onNext: { [weak self] _  in
            guard let self = self else { return }
            let controller = AddtionalPlaceController.init(nibName: "AddtionalPlaceController", bundle: nil)
            self.navigationController?.pushViewController(controller, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @IBAction private func courtStepper(_ sender: UIStepper) {
        courtCountLabel.text =  String(Int(sender.value))
    }
    
    @IBAction private func gatherStepper(_ sender: UIStepper) {
        gatherCountLabel.text = String(Int(sender.value))
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
