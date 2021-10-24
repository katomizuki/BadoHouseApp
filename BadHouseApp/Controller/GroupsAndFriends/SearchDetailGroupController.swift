import UIKit
import SkeletonView
protocol SearchDetailGroupDelegate: AnyObject {
    func seachDetailGroup(vc: SearchDetailGroupController, time: String, money: String, place: String)
}
class SearchDetailGroupController: UIViewController {
    // Mark Properties
    private let searchLabel: UILabel = ProfileLabel(title: "チーム詳細検索", num: 24)
    private let timeTextField = ProfileTextField(placeholder: "主な活動　○曜日")
    private let ｍoneyTextField = ProfileTextField(placeholder: "会費　〇〇円/月")
    private let placeTextFiled = ProfileTextField(placeholder: "場所  〇〇県")
    private lazy var searchButton: UIButton = {
        let button = RegisterButton(text: "検索")
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
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
    }
    // Mark setupMethod
    private func setupUI() {
        searchLabel.textColor = .white
        searchLabel.backgroundColor = Constants.AppColor.OriginalBlue
        navigationItem.title = "チーム詳細検索"
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let stack = UIStackView(arrangedSubviews: [timeTextField,
                                                   ｍoneyTextField,
                                                   placeTextFiled,
                                                   searchButton])
        view.addSubview(stack)
        view.addSubview(searchLabel)
        timeTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        stack.axis = .vertical
        stack.spacing = 15
        stack.distribution = .fillEqually
        searchLabel.anchor(bottom: stack.topAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingBottom: 25,
                           paddingRight: 0,
                           paddingLeft: 0,
                           height: 35)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 120,
                     paddingRight: 20,
                     paddingLeft: 20)
        setupPicker(pickerView: moneyPickerView, textField: ｍoneyTextField)
        setupPicker(pickerView: placePickerView, textField: placeTextFiled)
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
        let place = placeTextFiled.text ?? ""
        self.delegate?.seachDetailGroup(vc: self, time: time, money: money, place: place)
    }
    @objc private func donePicker() {
        placeTextFiled.endEditing(true)
        ｍoneyTextField.endEditing(true)
        timeTextField.endEditing(true)
    }
}
// Mark pickerDelegate
extension SearchDetailGroupController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.placePickerView {
            guard let text = Place(rawValue: row)?.name else { return }
            placeTextFiled.text = text
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
