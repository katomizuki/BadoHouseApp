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
        updateUI()
    }
    
    private func updateUI() {
        calendar.delegate = self
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        //Mark:addsubView
        view.addSubview(button)
        view.addSubview(textField)
        
        //Mark:anchor
        button.anchor(top:textField.bottomAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      paddingTop: 30,
                      paddingRight: 30,
                      paddingLeft: 30,height: 45)
        textField.anchor(top:calendar.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 30,paddingRight: 30,paddingLeft: 30,height: 45)
        
        //mark:addTarget
        button.addTarget(self, action: #selector(search), for: UIControl.Event.touchUpInside)
        textField.addTarget(self, action: #selector(placeSearch), for: UIControl.Event.valueChanged)

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
    
    //Mark:textfield
    @objc func placeSearch() {
    }
    
    //Mark:FScalendarDelegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.formatterUtil(date: date)
        self.searchDateString = dateString
    }

}

