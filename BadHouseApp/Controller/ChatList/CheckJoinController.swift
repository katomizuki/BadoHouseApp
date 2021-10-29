import UIKit
import XLPagerTabStrip
import Firebase

final class CheckJoinController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private var eventArray = [Event]()
    private let fetchData = FetchFirestoreData()
    private var notificationArray = [[User]]()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
    private func setupData() {
        fetchData.myDataDelegate = self
        EventServie.getmyEventId { [weak self] event in
            guard let self = self else { return }
            self.eventArray = event
            self.fetchData.fetchEventJoinData(eventArray: event)
        }
    }
}
// MARK: - XlPagerExtension
extension CheckJoinController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "参加確定者")
    }
}
// MARK: - FetchMyDataDelegate
extension CheckJoinController: FetchMyDataDelegate {
    func fetchMyJoinData(joinArray: [[String]]) {
        notificationArray = [[User]]()
        let group = DispatchGroup()
        for i in 0..<joinArray.count {
            var tempArray = [User]()
            for j in 0..<joinArray[i].count {
                group.enter()
                let id = joinArray[i][j]
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
            print(self.notificationArray)
            print(self.eventArray)
            self.tableView.reloadData()
        }
    }
}
// MARK: - TableViewDataSource
extension CheckJoinController: UITableViewDataSource {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.CellGroupId, for: indexPath) as! GroupCell
        cell.label.text = notificationArray[indexPath.section][indexPath.row].name
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
// MARK: - TableViewDelegate
extension CheckJoinController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVc = UIAlertController(title: "承認待ちにもどしますか", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default) { _ in
            let eventId = self.eventArray[indexPath.section].eventId
            let userId = self.notificationArray[indexPath.section][indexPath.row].uid
            DeleteService.deleteSubCollectionData(collecionName: "Event", documentId: eventId, subCollectionName: "Join", subId: userId)
            self.notificationArray[indexPath.section].remove(at: indexPath.row)
            JoinService.sendPreJoinData(eventId: eventId, userId: userId) { result in
                switch result {
                case .success:
                    self.tableView.reloadData()
                case .failure:
                    self.setupCDAlert(title: "参加者情報の変更に失敗しました",
                                      message: "",
                                      action: "OK",
                                      alertType: .warning)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "いいえ", style: .default)
        alertVc.addAction(alertAction)
        alertVc.addAction(cancleAction)
        present(alertVc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
