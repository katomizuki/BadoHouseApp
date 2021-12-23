
import UIKit

class SubUserDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var circleCollectionView: UICollectionView!
    
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var friendButton: UIButton! {
        didSet {
            friendButton.updateFriendButton()
            friendButton.isUserInteractionEnabled = true
        }
    }
    @IBOutlet private weak var friendLabel: UILabel! {
        didSet {
            friendLabel.font = .boldSystemFont(ofSize: 20)
            friendButton.isHidden = false
        }
    }
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var badmintonTimeLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var ageStackView: UIStackView!
    @IBOutlet private weak var genderStackView: UIStackView!
    @IBOutlet private weak var badmintonTimeStackView: UIStackView!
    @IBOutlet private weak var levleStackView: UIStackView!
    @IBOutlet weak var teamLabel: UILabel! {
        didSet {
            teamLabel.font = .boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet weak var chatImageView: UIButton! {
        didSet {
            chatImageView.isHidden = false
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
    private lazy var blockButton: UIButton = {
        let button = UIButton()
        button.setTitle("...", for: .normal)
        button.setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        button.addTarget(self, action: #selector(block), for: .touchUpInside)
        button.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        button.layer.borderWidth = 3
        button.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        button.toCorner(num: 15)
        return button
    }()
    var user: User?
    var me: User?
    var ownTeam = [TeamModel]()
    var userFriend = [User]()
    private var blockSheet: BlockSheet!
    private let cellId = "friendCellId"
    private let fetchData = FetchFirestoreData()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollection()
        setupData()
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
    // MARK: - setupMethod
    private func setupUI() {
        view.addSubview(blockButton)
        blockButton.anchor(left: friendButton.rightAnchor,
                           paddingLeft: 5,
                           centerY: friendButton.centerYAnchor,
                           width: 40,
                           height: 40)
        nameLabel.text = user?.name
        ageLabel.text = user?.age == "" || user?.age == nil || user?.age == "未設定" ? "未設定":user?.age
        genderLabel.text = user?.gender == "" || user?.gender == nil || user?.gender == "未設定" ? "未設定":user?.gender
        levelLabel.text = user?.level == "" || user?.level == nil || user?.level == "未設定" ? "未設定":user?.level
        badmintonTimeLabel.text = user?.badmintonTime == "" || user?.badmintonTime == nil || user?.badmintonTime == "未設定" ? "未設定":user?.badmintonTime
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
        circleCollectionView.delegate = self
        circleCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        fetchData.myDataDelegate = self
    }
    private func setupCollection() {
        let belongsNib = TeammemberCell.nib()
        circleCollectionView.register(belongsNib, forCellWithReuseIdentifier: "memberCellId")
        let friendNib = TeammemberCell.nib()
        friendCollectionView.register(friendNib, forCellWithReuseIdentifier: cellId)
        let layout = UICollectionViewFlowLayout()
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout.scrollDirection = .horizontal
        friendCollectionView.collectionViewLayout = layout2
        circleCollectionView.collectionViewLayout = layout
        setupDelegate()
        setupNeededMethod()
    }
    private func setupData() {
        let myId = AuthService.getUserId()
        guard let user = user else { return }
        UserService.searchFriend(friend: user, myId: myId) { [weak self] result in
            guard let self = self else { return }
            if result {
                self.friendsImageView.isUserInteractionEnabled = true
                self.chatButton.isHidden = false
                self.friendButton.plusFriendButton()
            } else {
                self.friendsImageView.isUserInteractionEnabled = false
                self.chatButton.isHidden = true
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
    // MARK: - selector
    @objc private func block() {
        print(#function)
        guard let me = self.me else { return }
        blockSheet = BlockSheet(user: me)
        blockSheet.delegate = self
        blockSheet.show()
    }
    // MARK: - IBAction
    @IBAction func plusFriend(_ sender: Any) {
        guard let user = user else { return }
        let myId = AuthService.getUserId()
        if friendButton.backgroundColor == UIColor(named: Constants.AppColor.darkColor) {
            friendButton.tapRemoveFriend()
            UserService.friendAction(myId: myId, friend: user, bool: true)
        } else {
            friendButton.tapPlusFriend()
            self.friendButton.setTitle(" バド友になる ", for: .normal)
            UserService.friendAction(myId: myId, friend: user, bool: false)
        }
    }
}
// MARK: - UserCollectionViewDelegate
extension SubUserDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == circleCollectionView && collectionView.tag == 0 {
            return ownTeam.count
        } else {
            return userFriend.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.circleCollectionView && collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCellId", for: indexPath) as! TeammemberCell
            let name = ownTeam[indexPath.row].teamName
            let urlString = ownTeam[indexPath.row].teamImageUrl
            cell.configure(name: name, url: urlString)
            cell.teamMemberImage.contentMode = .scaleAspectFill
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TeammemberCell
            let name = userFriend[indexPath.row].name
            let urlString = userFriend[indexPath.row].profileImageUrl
            cell.configure(name: name, url: urlString)
            return cell
        }
    }
}
// MARK: - CollectionDelegate
extension SubUserDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == circleCollectionView {
            let controller = CircleDetailController.init(nibName: "CircleDetailController", bundle: nil)
            controller.team = ownTeam[indexPath.row]
            controller.friends = userFriend
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = MainUserDetailController.init(nibName: "MainUserDetailController", bundle: nil)
            controller.user = userFriend[indexPath.row]
            controller.me = self.user
            controller.flag = true
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
// MARK: - CollectionLayoutDeelegate
extension SubUserDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
// MARK: - GetFriendDelegate
extension SubUserDetailController: FetchMyDataDelegate {
    func fetchMyFriendData(friendArray: [User]) {
        self.userFriend = []
        self.userFriend = friendArray
        DispatchQueue.main.async {
            self.friendCollectionView.reloadData()
        }
    }
}
// MARK: - MyTeamDelegate
extension SubUserDetailController {
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.ownTeam = []
        self.ownTeam = teamArray
        DispatchQueue.main.async {
            self.circleCollectionView.reloadData()
        }
    }
}
// MARK: - blockDelegate
extension SubUserDetailController: BlockDelegate {
    func blockSheet(option: BlockOptions) {
        switch option {
        case .dismiss:
            print("dismiss")
        case .block:
            print("dismiss")
            guard let user = self.user else { return }
            let vc = BlockController(user: user)
            vc.modalPresentationStyle = .formSheet
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}
// Mark BlockDelegate
extension SubUserDetailController: BlockDismissDelegate {
    func blockDismiss(vc: BlockController) {
        vc.dismiss(animated: true, completion: nil)
    }
}
