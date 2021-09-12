

import UIKit
import FSCalendar

protocol CalendarDelegate {
    func searchCalendar(dateString:String)
}

class CalendarViewController: UIViewController, FSCalendarDelegate {
    
    //Mark:Properties
    @IBOutlet weak var calendar: FSCalendar!
    var delegate:CalendarDelegate?
    private var searchDateString = String()
    private let button:UIButton = RegisterButton(text: "検索")
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(button)
        button.anchor(top:calendar.bottomAnchor,
                      left: view.leftAnchor,
                      right: view.rightAnchor,
                      paddingTop: 30,
                      paddingRight: 30,
                      paddingLeft: 30,height: 45)
        button.addTarget(self, action: #selector(search), for: UIControl.Event.touchUpInside)
    }
    
    //Mark:Selector
    @objc func search() {
        self.delegate?.searchCalendar(dateString: searchDateString)
        dismiss(animated: true, completion: nil)
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
