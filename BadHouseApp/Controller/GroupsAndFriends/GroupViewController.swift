import UIKit
import Firebase
import NVActivityIndicatorView
import FacebookCore

class GroupViewController: UIViewController{
    //Mark:Properties
    var user:User?
    var teamArray = [TeamModel]()
    var friendArray = [User]()
    private let cellId = Utility.CellId.CellGroupId
    private var userIdArray = [String]()
    private let sectionArray = ["所属サークル","お友達"]
    @IBOutlet private weak var groupTableView: UITableView! {
        didSet {
            groupTableView.separatorColor = Utility.AppColor.OriginalBlue
        }
    }
    private var IndicatorView:NVActivityIndicatorView!
    @IBOutlet private weak var myImageView: UIImageView! {
        didSet {
            myImageView.toCorner(num: 40)
        }
    }
    @IBOutlet private weak var myName: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    private let fetchData = FetchFirestoreData()
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        IndicatorView.startAnimating()
        setupTableView()
        setupData()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    //Mark: setupMethod
    private func setupData() {
        fetchData.friendDelegate = self
        fetchData.myTeamDelegate = self
        let uid = Auth.getUserId()
        Firestore.getUserData(uid: uid) { [weak self] user in
            guard let self = self else { return }
            guard let user = user else { return }
            self.user = user
            let urlString = user.profileImageUrl
            if urlString == "" {
                self.myImageView.image = UIImage(named: Utility.ImageName.noImages)
            } else {
                let url = URL(string: urlString)
                self.myImageView.sd_setImage(with: url, completed: nil)
            }
            self.myName.text = user.name
        }
        Firestore.getOwnTeam(uid: uid) { [weak self] teamId in
            guard let self = self else { return }
            self.fetchData.getmyTeamData(idArray: teamId)
        }
        Firestore.getFriendData(uid: uid) { [weak self] usersId in
            guard let self = self else { return }
            self.fetchData.friendData(idArray: usersId)
        }
    }
    
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        let nib = GroupCell.nib()
        groupTableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
        
    }
    //Mark:IBAction
    @IBAction private func user(_ sender: Any) {
        self.performSegue(withIdentifier:  Utility.Segue.userProfile, sender: nil)
    }
    
    @IBAction private func gotoMakeGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.MakeGroupVC) as! MakeGroupViewController
        vc.me = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func scroll(_ sender: Any) {
        if teamArray.count != 0 && friendArray.count != 0 {
            groupTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    //Mark:prepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Utility.Segue.userProfile {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        } else if segue.identifier == Utility.Segue.gotoSearch {
            let vc = segue.destination as! GroupSearchViewController
            vc.friends = self.friendArray
        }
    }
}
//Mark:UItableViewDelegate,DataSource
extension GroupViewController:UITableViewDelegate,UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupDetailVC) as! GroupDetailViewController
            vc.team = teamArray[indexPath.row]
            vc.friends = friendArray
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.UserDetailVC) as! UserDetailViewController
            vc.user = friendArray[indexPath.row]
            vc.me = self.user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Utility.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
//Mark freindDelegate
extension GroupViewController:GetFriendDelegate {
    
    func getFriend(friendArray: [User]) {
        self.friendArray = []
        self.friendArray = friendArray
        self.groupTableView.reloadData()
    }
}
//Mark myTeamDelegate
extension GroupViewController:GetMyTeamDelegate {
    func getMyteam(teamArray: [TeamModel]) {
        self.teamArray = []
        self.teamArray = teamArray
        self.countLabel.text = "お友達 \(self.friendArray.count)人  所属サークル \(self.teamArray.count)グループ"
        self.IndicatorView.stopAnimating()
        groupTableView.reloadData()
    }
}
