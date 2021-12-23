import UIKit
import FirebaseAuth
import Firebase
import SDWebImage
import FSCalendar

protocol MyScheduleDelegate: AnyObject {
    func dismissMyScheduleVC(vc: MyScheduleController)
}
final class MyScheduleController: UIViewController {
    // MARK: - Properties
    var me: User?
    private let cellId = "cellGroupId"
    private var eventArray = [Event]()
    private let tableview: UITableView = {
        let tv = UITableView()
        return tv
    }()
    private let calendar: FSCalendar = {
        let view = FSCalendar()
        return view
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    weak var delegate: MyScheduleDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
        setupTableView()
    }
  
    private func setupCalendar() {
        view.addSubview(backButton)
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        calendar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        right: view.rightAnchor,
                        paddingTop: 60,
                        paddingRight: 20,
                        paddingLeft: 20,
                        height: 350)
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        calendar.appearance.titleDefaultColor = .systemGray3
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.todayColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        calendar.calendarWeekdayView.weekdayLabels[1].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[2].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[3].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[4].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[5].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[6].font = UIFont.boldSystemFont(ofSize: 16)
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .systemRed
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .systemBlue
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
    }
    private func setupTableView() {
        view.addSubview(tableview)
        tableview.anchor(top: calendar.bottomAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 40,
                         paddingBottom: 20,
                         paddingRight: 0,
                         paddingLeft: 0)
        tableview.delegate = self
        tableview.dataSource = self
        let nib = TalkCell.nib()
        tableview.register(nib, forCellReuseIdentifier: cellId)
    }
    // MARK: - Initialize
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.me = user
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selector
    @objc private func back() {
        self.delegate?.dismissMyScheduleVC(vc: self)
    }
}
// MARK: - UITableViewDataSource
extension MyScheduleController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TalkCell
        let event = eventArray[indexPath.row]
        cell.event = event
        cell.trashDelegate = self
        return cell
    }
}

// MARK: - FetchMyDataDelegate FetchMyDataDelegate FSCalendarDelegateAppearance
extension MyScheduleController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let date = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss Z")
        let dateString = date.prefix(10)
        if eventArray.isEmpty == false {
            let array = eventArray.filter { $0.eventStartTime.prefix(10) == dateString }
            return array.count
        } else {
            return 0
        }
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let date = DateUtils.stringFromDate(date: date, format: "yyyy/MM/dd HH:mm:ss Z")
        let dateString = date.prefix(10)
        if eventArray.isEmpty == false {
            for i in 0..<eventArray.count {
                if eventArray[i].eventStartTime.prefix(10) == dateString {
                    return .systemBlue
                }
            }
        } else {
            return nil
        }
        return nil
    }
}
// MARK: - CalendarEventDelegate
extension MyScheduleController: CalendarEventDelegate {
    func removeEvent(eventModel: Event, cell: UITableViewCell) {
        guard let tappedIndex = tableview.indexPath(for: cell)?[1] else { return }
        let vc = UIAlertController(title: "こちらの予定を削除しますか？", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let meId = self.me?.uid else { return }
            let eventId = self.eventArray[tappedIndex].eventId
            DeleteService.deleteSubCollectionData(collecionName: "Users",
                                                  documentId: meId,
                                                  subCollectionName: "Join",
                                                  subId: eventId)
            self.eventArray.remove(at: tappedIndex)
            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.calendar.reloadData()
            }
        }
        let cancleAction = UIAlertAction(title: "いいえ", style: .cancel)
        vc.addAction(alertAction)
        vc.addAction(cancleAction)
        present(vc, animated: true, completion: nil)
    }
}
