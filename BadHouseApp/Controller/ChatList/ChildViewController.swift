import UIKit
import XLPagerTabStrip
import Firebase
import SDWebImage
import NVActivityIndicatorView

class ChildViewController: UIViewController {
    
    private var eventArray = [Event]()
    private let fetchData = FetchFirestoreData()
    @IBOutlet weak var tableView: UITableView!
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
    }
    
    //Mark:NVActivityIndicatorView
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
    
    private func setupData() {
        fetchData.preDelegate = self
        Firestore.getmyEventId { event in
            self.eventArray = event
            self.fetchData.getEventPreJoinData(eventArray: event)
        }
    }
    
   
    
}
extension ChildViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "承認待ち")
    }
}

extension ChildViewController:GetPrejoinDataDelegate {
    func getPrejoin(preJoin: [[String]]) {
        self.notificationArray = [[User]]()
        for i in 0..<preJoin.count {
            var tempArray = [User]()
            for j in 0..<preJoin[i].count {
                let id = preJoin[i][j]
                Firestore.getUserData(uid: id) { user in
                    guard let user = user else { return }
                    tempArray.append(user)
                    print(tempArray)
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

extension ChildViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventArray.count
    }
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.CellId.CellGroupId,for: indexPath) as! GroupCell
        cell.label.text = "\(notificationArray[indexPath.section][indexPath.row].name)さんから参加承認がきています"
        cell.label.numberOfLines = 0
        let urlString = notificationArray[indexPath.section][indexPath.row].profileImageUrl
        let url = URL(string: urlString)
        cell.cellImagevView.sd_setImage(with: url, completed: nil)
        cell.cellImagevView.layer.cornerRadius = 30
        cell.cellImagevView.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventArray[section].eventTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let alertVC = UIAlertController(title: "参加申請を許可しますか？", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default) { _ in
            let eventId = self.eventArray[indexPath.section].eventId
            let userId = self.notificationArray[indexPath.section][indexPath.row].uid
            Firestore.deleteSubCollectionData(collecionName: "Event", documentId: eventId, subCollectionName: "PreJoin", subId: userId)
            self.notificationArray[indexPath.section].remove(at: indexPath.row)
            Firestore.sendJoin(eventId: eventId, uid: userId)
            tableView.reloadData()
          }
        let cancleAction = UIAlertAction(title: "いいえ", style: .default) { _ in
        }
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Utility.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


