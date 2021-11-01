import UIKit
import FSCalendar
import CDAlertView
import PKHUD

protocol SearchCalendarDelegate: AnyObject {
    func didTapSearchButton(dateString: String, text: String, vc: SearchCalendarController)
    func dismissCalendarVC(vc: SearchCalendarController)
}
final class SearchCalendarController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var calendar: FSCalendar!
    weak var delegate: SearchCalendarDelegate?
    private var searchDateString = String()
    private lazy var searchButton: UIButton = {
        let button = RegisterButton(text: "検索")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(search), for: UIControl.Event.touchUpInside)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let textField: UITextField = RegisterTextField(placeholder: "都道府県選択")
    private let placePicker = UIPickerView()
    private let placeArray = Constants.Data.placeArray
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCalendar()
    }
    // MARK: - SetupMethod
    private func setupUI() {
        view.addSubview(searchButton)
        view.addSubview(textField)
        view.addSubview(backButton)
        searchButton.anchor(top: textField.bottomAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      paddingTop: 10,
                      paddingRight: 30,
                      paddingLeft: 30,
                      height: 45)
        textField.anchor(top: calendar.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 10,
                         paddingRight: 30,
                         paddingLeft: 30,
                         height: 45)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
        textField.inputView = placePicker
        placePicker.delegate = self
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
    private func setupCalendar() {
        calendar.delegate = self
        calendar.appearance.weekdayTextColor = Constants.AppColor.OriginalBlue
        calendar.appearance.headerTitleColor = Constants.AppColor.OriginalBlue
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.selectionColor = Constants.AppColor.OriginalBlue
        calendar.appearance.titleDefaultColor = .systemGray
        calendar.today = nil
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        calendar.calendarWeekdayView.weekdayLabels[0].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[1].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[2].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[3].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[4].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[5].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[6].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue
    }
    // MARK: - SelectorMethod
    @objc func search() {
        if searchDateString.isEmpty {
            self.setupCDAlert(title: "検索エラー",
                              message: "日程を指定してください",
                              action: "OK",
                              alertType: CDAlertViewType.error)
            return
        }
        guard let text = textField.text else { return }
        if text.isEmpty {
            self.setupCDAlert(title: "検索エラー",
                              message: "１文字以上入力してください",
                              action: "OK",
                              alertType: CDAlertViewType.error)
            return
        }
        self.delegate?.didTapSearchButton(dateString: searchDateString, text: text, vc: self)
    }
    @objc private func back() {
        self.delegate?.dismissCalendarVC(vc: self)
    }
    @objc private func donePicker() {
        textField.endEditing(true)
    }
}
// MARK: - FSCalendarDelegate
extension SearchCalendarController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatterUtil(date: date)
        self.searchDateString = dateString
    }
}
// MARK: - PickerViewDelegate
extension SearchCalendarController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let place = placeArray[row]
        textField.text = place
        if !textField.text!.isEmpty == true {
            textField.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
            textField.layer.borderWidth = 3
        } else {
            textField.layer.borderColor = UIColor.systemGray.cgColor
            textField.layer.borderWidth = 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(placeArray)
        return placeArray[row]
    }
}
// MARK: - PickerViewDataSource
extension SearchCalendarController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
