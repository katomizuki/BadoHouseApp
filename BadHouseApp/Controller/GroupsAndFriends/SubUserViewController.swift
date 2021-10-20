import UIKit
import Firebase
import SDWebImage
import FacebookCore

class SubUserViewController: UIViewController , UIPopoverPresentationControllerDelegate{
    
    //Mark: Properties
    var user:User?
    var me:User?
    var ownTeam = [TeamModel]()
    var userFriend = [User]()
    @IBOutlet private weak var friendCollectionView: UICollectionView!
    @IBOutlet private weak var belongCollectionView: UICollectionView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var friendButton: UIButton! {
        didSet {
            friendButton.updateFriendButton()
        }
    }
    @IBOutlet private weak var friendLabel: UILabel! {
        didSet {
            friendLabel.font = UIFont.boldSystemFont(ofSize:20)
            friendButton.isHidden = true
        }
    }
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var badmintoTimeLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var ageStackView: UIStackView!
    @IBOutlet private weak var genderStackView: UIStackView!
    @IBOutlet private weak var badmintonTimeStackView: UIStackView!
    @IBOutlet private weak var levelStackView: UIStackView!
    private let fetchData = FetchFirestoreData()
    @IBOutlet private weak var teamLabel: UILabel! {
        didSet {
            teamLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet weak var chatImage: UIButton! {
        didSet {
            chatImage.isHidden = true
        }
    }
    @IBOutlet private weak var friendsImageView: UIImageView! {
        didSet {
            friendsImageView.contentMode = .scaleToFill
            friendsImageView.chageCircle()
            friendsImageView.layer.borderWidth = 4
            friendsImageView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayer()
        setupCollection()
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.title = user?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    //Mark:setupMethod
    private func setupUI() {
        nameLabel.text = user?.name
        ageLabel.text = user?.age == "" || user?.age == nil || user?.age == "未設定" ? "未設定":user?.age
        genderLabel.text = user?.gender == "" || user?.gender == nil || user?.gender == "未設定" ? "未設定":user?.gender
        levelLabel.text = user?.level == "" || user?.level == nil || user?.level == "未設定" ? "未設定":user?.level
        badmintoTimeLabel.text = user?.badmintonTime == "" || user?.badmintonTime == nil || user?.badmintonTime == "未設定" ? "未設定":user?.badmintonTime
        if user?.uid == me?.uid {
            friendButton.isHidden = true
        }
    }
    private func setupLayer() {
        //        setupBorder(view: ageStackView)
        //        setupBorder(view: genderStackView)
        //        setupBorder(view: badmintonTimeStackView)
    }
    
    private func setupBorder(view:UIView) {
        let border = CALayer()
        border.frame = CGRect(x: view.frame.width - 1, y: 15, width: 5.0, height: view.frame.height)
        border.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(border)
    }
    
    private func setupDelegate() {
        belongCollectionView.delegate = self
        belongCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        fetchData.myFriendDelegate = self
//        fetchData.myTeamDelegate = self
    }
    
    private func setupCollection() {
        let belongsNib = TeammemberCell.nib()
        belongCollectionView.register(belongsNib, forCellWithReuseIdentifier: Constants.CellId.MemberCellId)
        let friendNib = TeammemberCell.nib()
        friendCollectionView.register(friendNib, forCellWithReuseIdentifier: Constants.CellId.friendCellId)
        let layout = UICollectionViewFlowLayout()
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout.scrollDirection = .horizontal
        friendCollectionView.collectionViewLayout = layout2
        belongCollectionView.collectionViewLayout = layout
        setupDelegate()
        setupNeededMethod()
    }
    
    private func setupData() {
        let myId = AuthService.getUserId()
        guard let user = user else { return }
        UserService.searchFriend(friend: user, myId: myId) { [weak self] result in
            guard let self = self else { return }
            if result {
                self.friendButton.plusFriendButton()
            } else {
                self.friendButton.removeFriendButton()
            }
        }
    }
    private func setupNeededMethod() {
        self.userFriend = []
        guard let memberId = user?.uid else { return }
        guard let urlString = user?.profileImageUrl else { return }
        if urlString == "" {
            friendsImageView.image = UIImage(named: Constants.ImageName.noImages)
        } else {
            let url = URL(string: urlString)
            friendsImageView.sd_setImage(with: url, completed: nil)
        }
        UserService.getOwnTeam(uid: memberId) { [weak self] teamIds in
            guard let self = self else { return }
            self.fetchData.fetchMyTeamData(idArray: teamIds)
        }
        UserService.getFriendData(uid: memberId) {[weak self] friends in
            guard let self = self else { return }
            self.fetchData.fetchMyFriendData(idArray: friends)
        }
    }
}
//Mark: UserCollectionViewDelegate
extension SubUserViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == belongCollectionView && collectionView.tag == 0 {
            return ownTeam.count
        } else  {
            return userFriend.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.belongCollectionView && collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.MemberCellId, for: indexPath) as! TeammemberCell
            let name = ownTeam[indexPath.row].teamName
            let urlString = ownTeam[indexPath.row].teamImageUrl
            cell.configure(name: name, urlString: urlString)
            cell.teamMemberImage.contentMode = .scaleAspectFill
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.friendCellId, for: indexPath) as! TeammemberCell
            let name = userFriend[indexPath.row].name
            let urlString = userFriend[indexPath.row].profileImageUrl
            cell.configure(name: name, urlString: urlString)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == belongCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupDetailVC) as! GroupDetailController
            vc.team = ownTeam[indexPath.row]
            vc.friends = userFriend
            vc.flag = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.UserDetailVC) as! UserDetailController
            vc.user = userFriend[indexPath.row]
            vc.me = self.user
            vc.flag = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//Mark GetFriendDelegate
extension SubUserViewController:FetchMyFriendDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.userFriend = []
        self.userFriend = friendArray
        DispatchQueue.main.async {
            self.friendCollectionView.reloadData()
        }
    }
}
//Mark MyTeamDelegate
extension SubUserViewController:FetchMyTeamDataDelegate {
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.ownTeam = teamArray
        DispatchQueue.main.async {
            self.belongCollectionView.reloadData()
        }
    }
}

