import UIKit
import SkeletonView
protocol SearchDetailGroupDelegate: AnyObject {
    func seachDetailGroup(vc: SearchDetailGroupController, time: String, money: String, place: String)
    func dismissGroupVC(vc: SearchDetailGroupController)
}
class SearchDetailGroupController: UIViewController {
    // Mark Properties
    private let timeTextField = ProfileTextField(placeholder: "主な活動　○曜日")
    private let ｍoneyTextField = ProfileTextField(placeholder: "会費　〇〇円/月")
    private let placeTextField = ProfileTextField(placeholder: "場所  〇〇県")
    private lazy var searchButton: UIButton = {
        let button = RegisterButton(text: "検索")
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        button.backgroundColor = Constants.AppColor.OriginalBlue
        return button
    }()
    private let moneyPickerView = UIPickerView()
    private let placePickerView = UIPickerView()
    private let dayPickerView = UIPickerView()
    private let moneyArray = Constants.Data.moneyArray
    private let dayArray = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
    weak var delegate: SearchDetailGroupDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "検索条件"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        return label
    }()
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    // Mark setupMethod
    private func setupUI() {
        placeTextField.returnKeyType = .next
        placeTextField.keyboardType = .namePhonePad
        placeTextField.backgroundColor = UIColor(named: "TFColor")
        placeTextField.layer.borderColor = UIColor.systemGray.cgColor
        ｍoneyTextField.returnKeyType = .next
        ｍoneyTextField.keyboardType = .namePhonePad
        ｍoneyTextField.backgroundColor = UIColor(named: "TFColor")
        ｍoneyTextField.layer.borderColor = UIColor.systemGray.cgColor
        timeTextField.returnKeyType = .next
        timeTextField.keyboardType = .namePhonePad
        timeTextField.backgroundColor = UIColor(named: "TFColor")
        timeTextField.layer.borderColor = UIColor.systemGray.cgColor
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let stack = UIStackView(arrangedSubviews: [timeTextField,
                                                   ｍoneyTextField,
                                                   placeTextField,
                                                   searchButton])
        view.addSubview(stack)
        view.addSubview(searchLabel)
        view.addSubview(backButton)
        timeTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fillEqually
        view.addSubview(backButton)
        view.addSubview(searchLabel)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
        searchLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           centerX: view.centerXAnchor,
                           centerY: backButton.centerYAnchor,
                           height: 35)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 120,
                     paddingRight: 20,
                     paddingLeft: 20)
        setupPicker(pickerView: moneyPickerView, textField: ｍoneyTextField)
        setupPicker(pickerView: placePickerView, textField: placeTextField)
        setupPicker(pickerView: dayPickerView, textField: timeTextField)
    }
    private func setupPicker(pickerView: UIPickerView, textField: UITextField) {
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
    // Mark Selector
    @objc private func didTapSearchButton() {
        print(#function)
        let time = timeTextField.text ?? ""
        let money = timeTextField.text ?? ""
        let place = placeTextField.text ?? ""
        self.delegate?.seachDetailGroup(vc: self, time: time, money: money, place: place)
    }
    @objc private func donePicker() {
        placeTextField.endEditing(true)
        ｍoneyTextField.endEditing(true)
        timeTextField.endEditing(true)
    }
    @objc private func back() {
        self.delegate?.dismissGroupVC(vc: self)
    }
}
// Mark pickerDelegate
extension SearchDetailGroupController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.placePickerView {
            guard let text = Place(rawValue: row)?.name else { return }
            placeTextField.text = text
        } else if pickerView == self.dayPickerView {
            timeTextField.text = dayArray[row]
        } else {
            ｍoneyTextField.text = moneyArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.placePickerView {
            guard let text = Place(rawValue: row)?.name else { return nil }
            return text
        } else if pickerView == self.dayPickerView {
            return dayArray[row]
        } else {
            return moneyArray[row]
        }
    }
}
// Mark UipickerDataSource
extension SearchDetailGroupController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.placePickerView {
            return Place.allCases.count
        } else if pickerView == self.dayPickerView {
            return dayArray.count
        } else {
            return moneyArray.count
        }
    }
}
