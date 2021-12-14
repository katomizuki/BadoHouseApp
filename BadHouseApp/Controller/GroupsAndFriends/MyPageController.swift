import UIKit
import Firebase
import RxSwift
import RxCocoa
final class MyPageController: UIViewController {
    // MARK: - Properties
    var user: User?
    var teamArray = [TeamModel]()
    var friendArray = [User]()
    private let cellId = "cellGroupId"
    private var userIdArray = [String]()
    private let sectionArray = ["所属チーム", "バド友"]
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var groupTableView: UITableView! {
        didSet {
            groupTableView.separatorColor = Constants.AppColor.OriginalBlue
        }
    }
    @IBOutlet private weak var myImageView: UIImageView! {
        didSet {
            myImageView.toCorner(num: 40)
        }
    }
    @IBOutlet private weak var myName: UILabel! {
        didSet {
            myName.text = Constants.appName
        }
    }
    @IBOutlet private weak var countLabel: UILabel! {
        didSet {
            countLabel.font = .boldSystemFont(ofSize: 14)
            countLabel.textColor = .systemGray
        }
    }
    @IBOutlet private weak var searchCircleButton: UIBarButtonItem!
    private let disposeBag = DisposeBag()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        searchCircleButton.rx.tap.asDriver().drive { [weak self] _ in
            guard let self = self else { return }
            let controller = CircleSearchController.init(nibName: "CircleSearchController", bundle: nil)
            controller.modalPresentationStyle = .fullScreen
            controller.friends = self.friendArray
            self.present(controller, animated: true)
        }.disposed(by: disposeBag)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let vc = tabBarController?.viewControllers?[0]
            tabBarController?.selectedViewController = vc
        } else {
            setupData()
        }
    }
    // MARK: - setupMethod
    private func setupData() {
        fetchData.myDataDelegate = self
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
    // MARK: - IBAction
    @IBAction private func user(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.userProfile.rawValue, sender: nil)
    }
    @IBAction private func gotoMakeGroup(_ sender: Any) {
        let controller = MakeCircleController.init(nibName: "MakeCircleController", bundle: nil)
        controller.myData = user
        navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction private func scroll(_ sender: Any) {
        if teamArray.count != 0 && friendArray.count != 0 {
            groupTableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    // MARK: - PrepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Segue.userProfile.rawValue {
            let vc = segue.destination as! UserPageController
            vc.user = self.user
            vc.delegate = self
        } 
    }
}
// MARK: - UItableViewDataSource
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
// MARK: - UITableViewDelegate
extension MyPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerID.GroupDetailVC) as! GroupDetailController
            vc.team = teamArray[indexPath.row]
            vc.friends = friendArray
            vc.me = self.user
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerID.UserDetailVC) as! UserDetailController
            vc.user = friendArray[indexPath.row]
            vc.me = self.user
            vc.flag = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .systemGray6
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let friendId = friendArray[indexPath.row].uid
        guard let myId = user?.uid else { return }
        if editingStyle == .delete {
            let alertVC = UIAlertController(title: "このユーザーをブロックしますか", message: "", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "ブロック", style: .default) { _ in
                Ref.UsersRef.document(friendId).collection("Friends").document(myId).delete()
                Ref.UsersRef.document(myId).collection("Friends").document(friendId).delete()
                self.friendArray.remove(at: indexPath.row)
                self.groupTableView.reloadData()
            }
            let cancleAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alertVC.addAction(alertAction)
            alertVC.addAction(cancleAction)
            present(alertVC, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
}
// MARK: - FetchMyDataDelegate
extension MyPageController: FetchMyDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.friendArray = []
        self.friendArray = friendArray
        DispatchQueue.main.async {
            self.groupTableView.reloadData()
        }
    }
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.teamArray = []
        var array = teamArray
        array = array.sorted { element, nextElement in
            return element.updatedAt.dateValue() > nextElement.updatedAt.dateValue()
        }
        self.teamArray = array
        self.countLabel.text = "お友達 \(self.friendArray.count)人  所属サークル \(self.teamArray.count)グループ"
        DispatchQueue.main.async {
            self.groupTableView.reloadData()
        }
    }
}
// MARK: - UserDismissDelegate
extension MyPageController: UserDismissDelegate {
    func userVCdismiss(vc: UserPageController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
