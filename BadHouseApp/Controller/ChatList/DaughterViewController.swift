import UIKit
import XLPagerTabStrip
import Firebase
import NVActivityIndicatorView

class DaughterViewController: UIViewController {

    //Mark:Properties
    @IBOutlet weak var tableView: UITableView!
    private var eventArray = [Event]()
    private let fetchData = FetchFirestoreData()
    private var notificationArray = [[User]]()
    private var IndicatorView:NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupData()
    }
    
    //Mark:setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
    }
    
    //Mark setupData
    private func setupData() {
        fetchData.joinDelegate = self
        Firestore.getmyEventId { event in
            self.eventArray = event
            print(event)
            self.fetchData.fetchJoinData(eventArray: event)
        }
    }
    
    //Mark:NVActivityIndicatorView
    private func setupIndicator() {
        let frame = CGRect(x: view.frame.width / 2,
                           y: view.frame.height / 2,
                           width: 60,
                           height: 60)
        IndicatorView = NVActivityIndicatorView(frame: frame,
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
    
    
    
}

//Mark:xlPager
extension DaughterViewController:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "参加確定者")
    }
}

//Mark:getJoinDelegate
extension DaughterViewController:GetJoinDataDelegate {
    
    func getJoin(joinArray: [[String]]) {
//        IndicatorView.startAnimating()
        notificationArray = [[User]]()
        for i in 0..<joinArray.count {
            var tempArray = [User]()
            for j in 0..<joinArray[i].count {
                let id = joinArray[i][j]
                Firestore.getUserData(uid: id) { user in
                    guard let user = user else { return }
                    tempArray.append(user)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.notificationArray.append(tempArray)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)  {
            self.IndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
}


extension DaughterViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationArray.isEmpty {
            return 0
        } else {
            for i in 0..<eventArray.count {
                if section == i {
                    return self.notificationArray[i].count
                }
            }
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.CellId.CellGroupId, for: indexPath) as! GroupCell
        cell.label.text = notificationArray[indexPath.section][indexPath.row].name
        let urlString = notificationArray[indexPath.section][indexPath.row].profileImageUrl
        let url = URL(string: urlString)
        cell.cellImagevView.sd_setImage(with: url, completed: nil)
        cell.cellImagevView.layer.cornerRadius = 30
        cell.cellImagevView.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Utility.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventArray[section].eventTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVc = UIAlertController(title: "承認待ちにもどしますか", message: "", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default) { action in
            print("alert")
            let eventId = self.eventArray[indexPath.section].eventId
            let userId = self.notificationArray[indexPath.section][indexPath.row].uid
            Firestore.deleteSubCollectionData(collecionName: "Event", documentId: eventId, subCollectionName: "Join", subId: userId)
            self.notificationArray[indexPath.section].remove(at: indexPath.row)
            Firestore.sendPreJoin(eventId: eventId, userId: userId)
            tableView.reloadData()
        }
        
        let cancleAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.default) { action in
            print("cancle")
        }
        alertVc.addAction(alertAction)
        alertVc.addAction(cancleAction)
        present(alertVc, animated: true, completion: nil)
    }
    
    
}
