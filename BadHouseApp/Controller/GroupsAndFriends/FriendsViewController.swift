import UIKit
import Firebase
import NVActivityIndicatorView

class FriendsViewController: UIViewController {
   
    //Mark: Properties
    @IBOutlet weak var friendTableView: UITableView!
//    private var cellId = "aaaa"
    private var cellId = Utility.CellId.FriendCellId
    var friends = [User]()
    var inviter = [User]()
    var teamName:String?
    var teamTime:String?
    var teamPlace:String?
    var teamLevel:String?
    var teamImage:UIImage?
    var me:User?
    @IBOutlet weak var inviteButton: UIButton!
    private var IndicatorView:NVActivityIndicatorView!
    var teamTagArray = [String]()
    var url:String?
    private let fetchData = FetchFirestoreData()

    //Mark CustomDelegate
    func someMethodWantToCall(cell:UITableViewCell) {
        let indexPathTapped = friendTableView.indexPath(for: cell)
        guard let index = indexPathTapped?[1] else { return }
        let friend = friends[index]
        if judgeInvite(userId: friend.uid) != nil {
            guard let  index = judgeInvite(userId: friend.uid) else { return }
            inviter.remove(at: index)
        } else {
            inviter.append(friend)
        }
    }
    
    //Mark: HelperMethod
    func judgeInvite(userId:String)->Int? {
        if inviter.isEmpty { return nil }
        for i in 0..<inviter.count {
            let friendId = inviter[i].uid
            if friendId == userId { return i }
        }
        return nil
    }

    //Mark: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        updateUI()
        setupIndicator()
        inviteButton.layer.cornerRadius = 15
        inviteButton.layer.masksToBounds = true
        friendTableView.separatorStyle = .none
    }
    
    //Mark:setupFriendTableView
    private func setupTableView() {
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
    }
    
    //Mark:updateUI()
    private func updateUI() {
        inviteButton.backgroundColor = Utility.AppColor.OriginalLightBlue
        inviteButton.backgroundColor = Utility.AppColor.OriginalBlue
        inviteButton.setTitleColor(.white, for: UIControl.State.normal)
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
    @IBAction func sendTeamData(_ sender: Any) {
        IndicatorView.startAnimating()
        guard let teamImage = self.teamImage else { return }
        guard let teamName = self.teamName else { return }
        guard let teamPlace = self.teamPlace else { return }
        guard let teamTime = self.teamTime else { return }
        guard let teamLevel = self.teamLevel else { return }
        guard let teamUrl = self.url else { return }
        guard let me = self.me else { return }
        inviter.append(me)
                Storage.addTeamImage(image: teamImage) { urlString in
                    Firestore.createTeam(teamName: teamName, teamPlace: teamPlace, teamTime: teamTime, teamLevel: teamLevel, teamImageUrl: urlString,friends:self.inviter, teamUrl: teamUrl, tagArray: self.teamTagArray)
                    self.IndicatorView.stopAnimating()
                    self.navigationController?.popToRootViewController(animated: true)
                }
    }
}

//Mark TableviewExtension
extension FriendsViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:cellId, for: indexPath) as! ContactCell
        cell.linkFriend = self
        cell.nameLabel.text = friends[indexPath.row].name
        let urlString = friends[indexPath.row].profileImageUrl
        let url = URL(string: urlString)
        if urlString == "" {
            //urlがからであれば違う画像を出す なければロゴ画像を一旦出す。
            cell.iv.image = UIImage(named: Utility.ImageName.logoImage)
        
        } else {
            cell.iv.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return friendTableView.frame.height / 10
    }
}


