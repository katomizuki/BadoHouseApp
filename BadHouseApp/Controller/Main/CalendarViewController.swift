import UIKit
import FSCalendar
import CDAlertView

protocol CalendarDelegate:AnyObject {
    func searchCalendar(dateString:String,text:String)
}

class CalendarViewController: UIViewController {
    //Mark:Properties
    @IBOutlet private weak var calendar: FSCalendar!
    weak var delegate:CalendarDelegate?
    private var searchDateString = String()
    private let button:UIButton = {
        let button = RegisterButton(text: "検索")
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    private let textField:UITextField = RegisterTextField(placeholder: "場所名入力")
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        calendar.delegate = self
        setupCalendar()
    }
    //Mark setupMethod
    private func setupUI() {
        view.addSubview(button)
        view.addSubview(textField)
        
        button.anchor(top:textField.bottomAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      paddingTop: 30,
                      paddingRight: 30,
                      paddingLeft: 30,height: 45)
        textField.anchor(top:calendar.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 30,paddingRight: 30,paddingLeft: 30,height: 45)
        
        button.addTarget(self, action: #selector(search), for: UIControl.Event.touchUpInside)
    }
    
    private func setupCalendar() {
        calendar.appearance.weekdayTextColor = Utility.AppColor.OriginalBlue
        calendar.appearance.headerTitleColor = Utility.AppColor.OriginalBlue
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 20)
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.selectionColor = Utility.AppColor.OriginalBlue
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
    //Mark:Selector
    @objc func search() {
        if searchDateString.isEmpty {
            self.setupCDAlert(title: "検索エラー", message: "日程を指定してください", action: "OK", alertType: CDAlertViewType.error)
            return
        }
        guard let text = textField.text else { return }
        if text.isEmpty {
            self.setupCDAlert(title: "検索エラー", message: "１文字以上入力してください", action: "OK", alertType: CDAlertViewType.error)
            return
        }
        self.delegate?.searchCalendar(dateString: searchDateString,text: text)
        dismiss(animated: true, completion: nil)
    }
}
//Mark FSCalendarDelegate
extension CalendarViewController:FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatterUtil(date: date)
        self.searchDateString = dateString
    }
}

