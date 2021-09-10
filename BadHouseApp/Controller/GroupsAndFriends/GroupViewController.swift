

import UIKit
import Firebase
import NVActivityIndicatorView

class GroupViewController: UIViewController {
    
    //Mark:Properties
    var user:User?
    var teamArray = [TeamModel]()
    var friendArray = [User]()
    private let cellId = Utility.CellId.CellGroupId
    private var userIdArray = [String]()
    private let sectionArray = ["所属サークル","お友達"]
    @IBOutlet weak var groupTableView: UITableView!
    private var IndicatorView:NVActivityIndicatorView!
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setBackBarButton()
        groupTableView.separatorColor = Utility.AppColor.OriginalBlue
        //Mark:NVActivityIndicatorView
        IndicatorView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width / 2,
                                                              y: view.frame.height / 2,
                                                              width: 60,
                                                              height: 60),
                                                type: NVActivityIndicatorType.ballSpinFadeLoader,
                                                color: Utility.AppColor.OriginalBlue,
                                                padding: 0)
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
        IndicatorView.startAnimating()
        fetchUserData()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        let nib = GroupCell.nib()
        groupTableView.register(nib, forCellReuseIdentifier: cellId)
        let uid = Auth.getUserId()
    
        Firestore.getOwnTeam(uid: uid) { teams in
            self.teamArray = teams
            Firestore.getFriendData(uid: uid) { usersId in
                self.friendArray = [User]()
                for i in 0..<usersId.count {
                    let id = usersId[i]
                    Firestore.getUserData(uid: id) { user in
                        guard let user = user else { return }
                        self.friendArray.append(user)
                    }
                }
                print(self.friendArray)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    
                    self.IndicatorView.stopAnimating()
                    self.groupTableView.reloadData()
                    
                }
            }
        }
    }
    
    
    //Mark UserData
    private func fetchUserData() {
        let uid = Auth.getUserId()
        Firestore.getUserData(uid: uid) { user in
            self.user = user
        }
    }
    
    //Mark:prepare(画面遷移）
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoMakeGroup {
            let vc = segue.destination as! MakeGroupViewController
            guard let user = self.user else { return }
                vc.me = user
        }
    }
}

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
        cell.accessoryType = .disclosureIndicator
        cell.label.font = UIFont.boldSystemFont(ofSize: 16)
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            cell.label.text = teamArray[indexPath.row].teamName
            let url = URL(string: teamArray[indexPath.row].teamImageUrl)
            cell.cellImagevView.sd_setImage(with: url, completed: nil)
            cell.cellImagevView.contentMode = .scaleAspectFill
            
            cell.cellImagevView.chageCircle()
        } else if indexPath.section == 1 {
            cell.label.text = friendArray[indexPath.row].name
            let url = URL(string: friendArray[indexPath.row].profileImageUrl)
            if friendArray[indexPath.row].profileImageUrl == "" {
                cell.cellImagevView.image = UIImage(named: Utility.ImageName.logoImage)
            } else {
            cell.cellImagevView.sd_setImage(with: url, completed: nil)
            }
            cell.cellImagevView.chageCircle()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //teamData
            let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupDetailVC) as! GroupDetailViewController
            vc.team = teamArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.UserDetailVC) as! UserDetailViewController
            vc.user = friendArray[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Utility.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    
}
