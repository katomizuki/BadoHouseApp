import UIKit
import Firebase
import NVActivityIndicatorView

class GroupViewController: UIViewController{
    
    //Mark:Properties
    var user:User?
    var teamArray = [TeamModel]()
    var friendArray = [User]()
    private let cellId = Utility.CellId.CellGroupId
    private var userIdArray = [String]()
    private let sectionArray = ["所属サークル","お友達"]
    @IBOutlet weak var groupTableView: UITableView!
    private var IndicatorView:NVActivityIndicatorView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    private let fetchData = FetchFirestoreData()
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.separatorColor = Utility.AppColor.OriginalBlue
        setupIndicator()
        IndicatorView.startAnimating()
        setupTableView()
        setupData()
        myImageView.layer.cornerRadius = 40
        myImageView.layer.masksToBounds = true
        fetchData.friendDelegate = self
    }
    
    //Mark: setupData {
    private func setupData() {
        let uid = Auth.getUserId()
        Firestore.getUserData(uid: uid) { user in
            guard let user = user else { return }
            self.user = user
            let urlString = user.profileImageUrl
            let url = URL(string: urlString)
            self.myImageView.sd_setImage(with: url, completed: nil)
            self.myName.text = user.name
        }
        Firestore.getOwnTeam(uid: uid) { teams in
            self.teamArray = teams
            Firestore.getFriendData(uid: uid) { usersId in
                self.friendArray = [User]()
                self.fetchData.friendData(idArray: usersId)
            }
        }
    }
    
    //Mark: setupDelegate
    private func setupTableView() {
        groupTableView.delegate = self
        groupTableView.dataSource = self
        let nib = GroupCell.nib()
        groupTableView.register(nib, forCellReuseIdentifier: cellId)
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
    
    //Mark:IBAction
    @IBAction func user(_ sender: Any) {
        self.performSegue(withIdentifier:  Utility.Segue.userProfile, sender: nil)
    }
    
    @IBAction func gotoMakeGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MakeGroupVC") as! MakeGroupViewController
        vc.me = user
        navigationController?.pushViewController(vc, animated: true)
    }
    //Mark:prepare(画面遷移）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  Utility.Segue.userProfile {
            let vc = segue.destination as! UserViewController
            vc.user = self.user
        }
    }
    
    @IBAction func scroll(_ sender: Any) {
        groupTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
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


extension GroupViewController :GetFriendDelegate {
    
    func getFriend(friendArray: [User]) {
        self.friendArray = []
        self.friendArray = friendArray
        self.countLabel.text = "お友達 \(self.friendArray.count)人  所属サークル \(self.teamArray.count)グループ"
        self.IndicatorView.stopAnimating()
        self.groupTableView.reloadData()
    }
    
    
}
