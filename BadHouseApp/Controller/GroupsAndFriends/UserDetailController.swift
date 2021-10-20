import UIKit
import Firebase
import SDWebImage
import FacebookCore

class UserDetailController: UIViewController {
    // Mark Properties
    var user: User?
    var me: User?
    var ownTeam = [TeamModel]()
    var userFriend = [User]()
    private var blockSheet: BlockSheet!
    @IBOutlet private weak var teamLabel: UILabel! {
        didSet {
            teamLabel.font = .boldSystemFont(ofSize: 20)
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
            friendLabel.font = .boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var badmintoTimeLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var ageStackView: UIStackView!
    @IBOutlet private weak var genderStackView: UIStackView!
    @IBOutlet private weak var badmintonTimeStackView: UIStackView!
    @IBOutlet private weak var levelStackView: UIStackView!
    private let fetchData = FetchFirestoreData()
    var flag = false
    private lazy var blockButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 通報 ", for: .normal)
        button.addTarget(self, action: #selector(block), for: .touchUpInside)
        button.backgroundColor = Constants.AppColor.OriginalBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollection()
        setupData()
        helperUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.title = user?.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    // Mark setupMethod
    private func setupUI() {
        view.addSubview(blockButton)
        blockButton.anchor(top: levelStackView.bottomAnchor,
                           right: view.rightAnchor,
                           paddingTop: 10,
                           paddingRight: 10,
                           width: 30,
                           height: 30)
        nameLabel.text = user?.name
        ageLabel.text = user?.age == "" || user?.age == nil || user?.age == "未設定" ? "未設定": user?.age
        genderLabel.text = user?.gender == "" || user?.gender == nil || user?.gender == "未設定" ? "未設定":user?.gender
        levelLabel.text = user?.level == "" || user?.level == nil || user?.level == "未設定" ? "未設定": user?.level
        badmintoTimeLabel.text = user?.badmintonTime == "" || user?.badmintonTime == nil || user?.badmintonTime == "未設定" ? "未設定":user?.badmintonTime
        if user?.uid == me?.uid {
            friendButton.isHidden = true
        }
    }
    private func setupBorder(view: UIView) {
        let border = CALayer()
        border.frame = CGRect(x: view.frame.width - 1,
                              y: 15,
                              width: 5.0,
                              height: view.frame.height)
        border.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(border)
    }
    private func setupDelegate() {
        belongCollectionView.delegate = self
        belongCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        fetchData.myFriendDelegate = self
        fetchData.myTeamDelegate = self
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
    // Mark HelperMethod
    private func helperUI() {
        print(#function)
        friendButton.isHidden = flag
        if user?.uid == me?.uid {
            friendButton.isHidden = true
        }
        friendsImageView.isUserInteractionEnabled = !flag
        chatButton.isHidden = flag
    }
    // Mark selector
    @objc private func block() {
        print(#function)
        blockSheet.delegate = self
        blockSheet.show()
    }
    // Mark IBAction
    @IBAction func plusFriend(_ sender: Any) {
        print(#function)
        friendButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        let myId = AuthService.getUserId()
        guard let user = user else { return }
        if friendButton.backgroundColor == .white {
            friendButton.tapRemoveFriend()
            UserService.friendAction(myId: myId, friend: user, bool: true)
        } else {
            friendButton.tapPlusFriend()
            self.friendButton.setTitle(" 友達申請 ", for: UIControl.State.normal)
            UserService.friendAction(myId: myId, friend: user, bool: false)
        }
    }
    @IBAction func gotoChat(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ChatVC) as! DMChatController
        vc.me = me
        vc.you = user
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoDM(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ChatVC) as! DMChatController
        vc.me = me
        vc.you = user
        navigationController?.pushViewController(vc, animated: true)
    }
}
// Mark UserCollectionViewDelegate
extension UserDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == belongCollectionView && collectionView.tag == 0 {
            return ownTeam.count
        } else {
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.friendCellId, for: indexPath) as! TeammemberCell
            let name = userFriend[indexPath.row].name
            let urlString = userFriend[indexPath.row].profileImageUrl
            cell.configure(name: name, urlString: urlString)
            return cell
        }
    }
}
// Mark CollectionViewDelegate
extension UserDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == belongCollectionView {
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupDetailVC) as! GroupDetailController
            vc.team = ownTeam[indexPath.row]
            vc.friends = userFriend
            vc.flag = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SubUserVC") as! SubUserDetailController
            vc.user = userFriend[indexPath.row]
            vc.me = self.user
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// Mark CollectionViewDelegateFlowLayout
extension UserDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
// Mark GetFriendDelegate
extension UserDetailController: FetchMyFriendDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.userFriend = []
        self.userFriend = friendArray
        DispatchQueue.main.async {
            self.friendCollectionView.reloadData()
        }
    }
}
// Mark MyTeamDelegate
extension UserDetailController: FetchMyTeamDataDelegate {
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.ownTeam = teamArray
        DispatchQueue.main.async {
            self.belongCollectionView.reloadData()
        }
    }
}
// Mark BlockSheetDelegate
extension UserDetailController: BlockDelegate {
    func blockSheet(option: BlockOptions) {
        print(option)
    }
}
