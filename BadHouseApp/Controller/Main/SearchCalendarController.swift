import UIKit
import FSCalendar
import CDAlertView

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
    private let textField: UITextField = RegisterTextField(placeholder: "場所名入力")
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
}
// MARK: - FSCalendarDelegate
extension SearchCalendarController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatterUtil(date: date)
        self.searchDateString = dateString
    }
}
