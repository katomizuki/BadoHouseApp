import UIKit
import FSCalendar
import CDAlertView

protocol CalendarDelegate {
    func searchCalendar(dateString:String,text:String)
}

class CalendarViewController: UIViewController, FSCalendarDelegate {
    
    //Mark:Properties
    @IBOutlet weak var calendar: FSCalendar!
    var delegate:CalendarDelegate?
    private var searchDateString = String()
    private let button:UIButton = RegisterButton(text: "検索")
    private let textField:UITextField = RegisterTextField(placeholder: "場所名入力")
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
        textField.addTarget(self, action: #selector(placeSearch), for: UIControl.Event.valueChanged)
    }
    
    //Mark:Selector
    @objc func search() {
        if searchDateString.isEmpty {
            let alertType = CDAlertViewType.error
            let alert = CDAlertView(title: "検索エラー", message: "日程を指定してください", type: alertType)
            let alertAction = CDAlertViewAction(title: "OK", font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
            
            alert.add(action: alertAction)
            alert.hideAnimations = { (center, transform, alpha) in
                transform = .identity
                alpha = 0
            }
            alert.show() { (alert) in
                print("completed")
            }
            return
        }
        guard let text = textField.text else { return }
        if text.isEmpty {
            let alertType = CDAlertViewType.error
            let alert = CDAlertView(title: "検索エラー", message: "１文字以上入力してください", type: alertType)
            let alertAction = CDAlertViewAction(title: "OK", font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
            
            alert.add(action: alertAction)
            alert.hideAnimations = { (center, transform, alpha) in
                transform = .identity
                alpha = 0
            }
            alert.show() { (alert) in
                print("completed")
            }

            return
        }
        self.delegate?.searchCalendar(dateString: searchDateString,text: text)
        dismiss(animated: true, completion: nil)
    }
    
    //Mark:textfield
    @objc func placeSearch() {
    }
    
    //Mark:FScalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let dateString = dateFormatter.string(from: date)
        self.searchDateString = dateString
    }

}

