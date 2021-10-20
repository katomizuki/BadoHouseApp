import UIKit
import Firebase
import NVActivityIndicatorView
import FacebookCore

class MyPageController: UIViewController {
    // Mark Properties
    var user: User?
    var teamArray = [TeamModel]()
    var friendArray = [User]()
    private let cellId = Constants.CellId.CellGroupId
    private var userIdArray = [String]()
    private let sectionArray = ["所属サークル", "お友達"]
    @IBOutlet private weak var groupTableView: UITableView! {
        didSet {
            groupTableView.separatorColor = Constants.AppColor.OriginalBlue
        }
    }
    private var indicatorView: NVActivityIndicatorView!
    @IBOutlet private weak var myImageView: UIImageView! {
        didSet {
            myImageView.toCorner(num: 40)
        }
    }
    @IBOutlet private weak var myName: UILabel!
    @IBOutlet private weak var countLabel: UILabel! {
        didSet {
            countLabel.font = .boldSystemFont(ofSize: 14)
        }
    }
    private let fetchData = FetchFirestoreData()
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        indicatorView.startAnimating()
        setupTableView()
        setupData()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let vc = tabBarController?.viewControllers?[0]
            tabBarController?.selectedViewController = vc
        } else {
            self.teamArray = []
            setupData()
        }
    }
    // Mark setupMethod
    private func setupData() {
        fetchData.myFriendDelegate = self
        fetchData.myTeamDelegate = self
        let uid = AuthService.getUserId()
        UserService.getUserData(uid: uid) { [weak self] user in
            guard let self = self else { return }
            guard let user = user else { return }
            self.user = user
            let urlString = user.profileImageUrl
            if urlString == "" {
                self.myImageView.image = UIImage(named: Constants.ImageName.noImages)
            } else {
                let url = URL(string: urlString)
                self.myImageView.sd_setImage(with: url, completed: nil)
            }
            self.myName.text = user.name
        }
        UserService.getOwnTeam(uid: uid) { [weak self] teamId in
            guard let self = self else { return }
            self.fetchData.fetchMyTeamData(idArray: teamId)
        }
        UserService.getFriendData(uid: uid) { [weak self] usersId in
            guard let self = self else { return }
            self.fetchData.fetchMyFriendData(idArray: usersId)
        }
    }
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        let nib = GroupCell.nib()
        groupTableView.register(nib, forCellReuseIdentifier: cellId)
    }
    private func setupIndicator() {
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
    }
    // Mark IBAction
    @IBAction private func user(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segue.userProfile, sender: nil)
    }
    @IBAction private func gotoMakeGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.MakeGroupVC) as! MakeGroupController
        vc.myData = user
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func scroll(_ sender: Any) {
        if teamArray.count != 0 && friendArray.count != 0 {
            groupTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    // Mark prepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Constants.Segue.userProfile {
            let vc = segue.destination as! MyPageUserInfoController
            vc.user = self.user
            vc.delegate = self
        } else if segue.identifier == Constants.Segue.gotoSearch {
            let vc = segue.destination as! GroupSearchController
            vc.friends = self.friendArray
        }
    }
}
// Mark UItableViewDataSource
extension MyPageController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return teamArray.count
        } else if section == 1 {
            return friendArray.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GroupCell
        if indexPath.section == 0 {
            let team = teamArray[indexPath.row]
            cell.team = team
        } else if indexPath.section == 1 {
            let user = friendArray[indexPath.row]
            cell.user = user
        }
        return cell
    }
}
// Mark uitableViewdelegate
extension MyPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupDetailVC) as! GroupDetailController
            vc.team = teamArray[indexPath.row]
            vc.friends = friendArray
            vc.me = self.user
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.UserDetailVC) as! UserDetailController
            vc.user = friendArray[indexPath.row]
            vc.me = self.user
            vc.flag = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
// Mark freindDelegate
extension MyPageController: FetchMyFriendDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.friendArray = []
        self.friendArray = friendArray
        DispatchQueue.main.async {
            self.groupTableView.reloadData()
        }
    }
}
// Mark myTeamDelegate
extension MyPageController: FetchMyTeamDataDelegate {
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.teamArray = []
        var array = teamArray
        array = array.sorted { element, nextElement in
            return element.updatedAt.dateValue() > nextElement.updatedAt.dateValue()
        }
        print(array)
        self.teamArray = array
        self.countLabel.text = "お友達 \(self.friendArray.count)人  所属サークル \(self.teamArray.count)グループ"
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.groupTableView.reloadData()
        }
    }
}
// Mark UserDismissDelegate
extension MyPageController: UserDismissDelegate {
    func userVCdismiss(vc: MyPageUserInfoController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
