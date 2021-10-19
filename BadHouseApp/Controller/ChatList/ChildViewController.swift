import UIKit
import XLPagerTabStrip
import Firebase
import SDWebImage
import NVActivityIndicatorView

class ChildViewController: UIViewController {
    //Mark properties
    private var eventArray = [Event]()
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var tableView: UITableView!
    private var notificationArray = [[User]]()
    private var IndicatorView:NVActivityIndicatorView!
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
    }
    //Mark setupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Constants.CellId.CellGroupId)
    }
    
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
        EventServie.getmyEventId { [weak self] event in
            guard let self = self else { return }
            self.eventArray = event
            self.fetchData.getEventPreJoinData(eventArray: event)
        }
    }
}
//Mark:IndicatorInfo-Extension
extension ChildViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "承認待ち")
    }
}
//Mark:getPrejoinDelegate
extension ChildViewController:GetPrejoinDataDelegate {
    func getPrejoin(preJoin: [[String]]) {
        self.notificationArray = [[User]]()
        let group = DispatchGroup()
        for i in 0..<preJoin.count {
            var tempArray = [User]()
            for j in 0..<preJoin[i].count {
                group.enter()
                let id = preJoin[i][j]
                UserService.getUserData(uid: id) { user in
                    defer { group.leave() }
                    guard let user = user else { return }
                    tempArray.append(user)
                }
            }
            group.notify(queue: .main) {
                self.notificationArray.append(tempArray)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.IndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
//Mark tableviewdelegate
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.CellGroupId,for: indexPath) as! GroupCell
        cell.label.text = "\(notificationArray[indexPath.section][indexPath.row].name)さんから参加承認がきています"
        cell.label.numberOfLines = 0
        let urlString = notificationArray[indexPath.section][indexPath.row].profileImageUrl
        if urlString == "" {
            cell.cellImagevView.image = UIImage(named: Constants.ImageName.noImages)
        } else {
            let url = URL(string: urlString)
            cell.cellImagevView.sd_setImage(with: url, completed: nil)
            cell.cellImagevView.toCorner(num: 30)
        }
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
            DeleteService.deleteSubCollectionData(collecionName: "Event", documentId: eventId, subCollectionName: "PreJoin", subId: userId)
            self.notificationArray[indexPath.section].remove(at: indexPath.row)
            let meId = AuthService.getUserId()
            JoinService.sendJoinData(eventId: eventId, uid: userId)
            self.fetchData.getChatData(meId: meId, youId: userId) { chatId in
                ChatRoomService.sendDMChat(chatroomId: chatId, senderId: meId, text: "承認者からの参加が確定しました。", reciverId: userId)
            }
            tableView.reloadData()
        }
        let cancleAction = UIAlertAction(title: "いいえ", style: .default) { _ in
        }
        alertVC.addAction(alertAction)
        alertVC.addAction(cancleAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}


