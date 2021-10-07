import UIKit
import FirebaseAuth
import Firebase
import SDWebImage
import FSCalendar
import FacebookCore

class ScheduleViewController: UIViewController{
    
    //Mark properties
    var me:User?
    private let cellId = Utility.CellId.CellGroupId
    private let fetchData = FetchFirestoreData()
    private var eventArray = [Event]()
    private let tableview:UITableView = {
        let tv = UITableView()
        return tv
    }()
    private let calendar:FSCalendar = {
        let view = FSCalendar()
        return view
    }()

    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCalendar()
        setupTableView()
        view.backgroundColor = .white
    }
    //Mark setupMethod
    private func setupData() {
        fetchData.myEventDelegate = self
        guard let meId = me?.uid else { return }
        Firestore.getmyEventIdArray(uid: meId) { [weak self] idArray in
            guard let self = self else { return }
            self.fetchData.getmyEventData(idArray: idArray)
        }
    }

    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        calendar.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leftAnchor,right: view.rightAnchor,paddingTop: 10,paddingRight: 20,paddingLeft: 20,height: 400)
    }
    
    private func setupTableView() {
        view.addSubview(tableview)
        tableview.anchor(top:calendar.bottomAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 40,paddingBottom:20, paddingRight:0, paddingLeft: 0)
        tableview.delegate = self
        tableview.dataSource = self
        let nib = GroupCell.nib()
        tableview.register(nib, forCellReuseIdentifier: cellId)
    }
    //Mark initialize
    init(user:User) {
        super.init(nibName: nil, bundle: nil)
        self.me = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//Mark: tableviewdelegate
extension ScheduleViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroupCell
        let event = eventArray[indexPath.row]
        cell.event = event
        cell.trashDelegate = self
        return cell
    }
}

//Mark:eventDelegate
extension ScheduleViewController:GetMyEventDelegate {

    func getEvent(eventArray: [Event]) {
        var array = eventArray
        array = eventArray.sorted { element, nextElement in
            guard let time = DateUtils.dateFromString(string: element.eventStartTime, format: "yyyy/MM/dd HH:mm:ss Z") else { return false}
            guard let nextTime = DateUtils.dateFromString(string: nextElement.eventStartTime, format: "yyyy/MM/dd HH:mm:ss Z") else { return false }
            return time < nextTime
        }
        self.eventArray = array
    
        tableview.reloadData()
        calendar.reloadData()
    }
}

//Mark FSCalendarDelegate
extension ScheduleViewController:FSCalendarDelegate,  FSCalendarDataSource,FSCalendarDelegateAppearance{
    
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
                    return Utility.AppColor.OriginalBlue
               }
            }
        } else {
            return nil
        }
        return nil
   }
}

//Mark:CalendarEventDelegate
extension ScheduleViewController:CalendarEventDelegate {
    
    func removeEvent(eventModel: Event,cell:UITableViewCell) {
        guard let tappedIndex = tableview.indexPath(for: cell)?[1] else { return }
        //showAlert主催者の方に連絡を入れたかどうかをチェックするアラート
        print(eventArray[tappedIndex])
        let vc = UIAlertController(title: "こちらの予定を削除しますか？", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.eventArray.remove(at: tappedIndex)
            //firestoreでも消す
            guard let meId = self.me?.uid else { return }
            let eventId = self.eventArray[tappedIndex].eventId
            Firestore.deleteSubCollectionData(collecionName: "Users", documentId: meId, subCollectionName: "Join", subId: eventId)
            self.tableview.reloadData()
            self.calendar.reloadData()
        }
        let cancleAction = UIAlertAction(title: "いいえ", style: .cancel)
        vc.addAction(alertAction)
        vc.addAction(cancleAction)
        present(vc, animated: true, completion: nil)
    }
}
