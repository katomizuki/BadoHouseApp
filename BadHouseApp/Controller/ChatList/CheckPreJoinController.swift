import UIKit
import XLPagerTabStrip
import Firebase
import SDWebImage
import NVActivityIndicatorView

final class CheckPreJoinController: UIViewController {
    // MARK: - Properties
    private var eventArray = [Event]()
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var tableView: UITableView!
    private var notificationArray = [[User]]()
    private var indicatorView: NVActivityIndicatorView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupIndicator()
        indicatorView.startAnimating()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupData()
    }
    // MARK: - SetupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Constants.CellId.CellGroupId)
    }
    private func setupIndicator() {
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
    }
    private func setupData() {
        fetchData.myDataDelegate = self
        EventServie.getmyEventId { [weak self] event in
            guard let self = self else { return }
            self.eventArray = event
            self.fetchData.fetchEventPreJoinData(eventArray: event)
        }
    }
}
// MARK: - IndicatorInfo-Extension
extension CheckPreJoinController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "承認待ち")
    }
}
// MARK: - FetchMyDataDelegate
extension CheckPreJoinController: FetchMyDataDelegate {
    func fetchMyPrejoinData(preJoinArray: [[String]]) {
        self.notificationArray = [[User]]()
        let group = DispatchGroup()
        for i in 0..<preJoinArray.count {
            var tempArray = [User]()
            for j in 0..<preJoinArray[i].count {
                group.enter()
                let id = preJoinArray[i][j]
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.indicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
}
// MARK: - TableviewDatasource
extension CheckPreJoinController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationArray.isEmpty {
            return 0
        } else {
            for i in 0..<eventArray.count where section == i {
                return self.notificationArray[i].count
            }
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.CellGroupId, for: indexPath) as! GroupCell
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
}
// MARK: - UITableViewDelegate
extension CheckPreJoinController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "参加申請を許可しますか？", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default) { _ in
            let eventId = self.eventArray[indexPath.section].eventId
            let userId = self.notificationArray[indexPath.section][indexPath.row].uid
            DeleteService.deleteSubCollectionData(collecionName: "Event", documentId: eventId, subCollectionName: "PreJoin", subId: userId)
            print(eventId)
            self.notificationArray[indexPath.section].remove(at: indexPath.row)
            let meId = AuthService.getUserId()
            JoinService.sendJoinData(eventId: eventId, uid: userId)
            ChatRoomService.getChatData(meId: meId, youId: userId) { chatId in
                ChatRoomService.sendDMChat(chatroomId: chatId,
                                           senderId: meId,
                                           text: "承認者からの参加が確定しました。",
                                           reciverId: userId) { result in
                    switch result {
                    case .success(let success):print(success)
                    case .failure(let error):print(error)
                    }
                }
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
        header.textLabel?.textColor = UIColor(named: Constants.AppColor.darkColor)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
