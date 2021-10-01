import UIKit
import Firebase
import SDWebImage
import FacebookCore

class UserDetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
   
    //Mark: Properties
    var user:User?
    var me:User?
    var ownTeam = [TeamModel]()
    var userFriend = [User]()
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var teamMemberImageView: UIImageView!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var belongCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var badmintoTimeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var ageStackView: UIStackView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var badmintonTimeStackView: UIStackView!
    @IBOutlet weak var levelStackView: UIStackView!
    private let fetchData = FetchFirestoreData()
   
    
    //Mark: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateBorder()
        setupCollection()
        setupData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let image = UIImage(named: "double")
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:Utility.AppColor.OriginalBlue]
        navigationItem.title = user?.name
    }
    
    //Mark:updateUI
    private func updateUI() {
        //Mark:UpdateUI
        friendButton.layer.cornerRadius = 15
        friendButton.layer.masksToBounds = true
        friendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        teamMemberImageView.contentMode = .scaleToFill
         teamMemberImageView.chageCircle()
        teamMemberImageView.layer.borderWidth = 4
        teamMemberImageView.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        teamLabel.font = UIFont.boldSystemFont(ofSize: 20)
        friendLabel.font = UIFont.boldSystemFont(ofSize:
            20)
        nameLabel.text = user?.name
        ageLabel.text = user?.age == "" || user?.age == nil || user?.age == "未設定" ? "未設定":user?.age
        genderLabel.text = user?.gender == "" || user?.gender == nil || user?.gender == "未設定" ? "未設定":user?.gender
        levelLabel.text = user?.level == "" || user?.level == nil || user?.level == "未設定" ? "未設定":user?.level
        badmintoTimeLabel.text = user?.badmintonTime == "" || user?.badmintonTime == nil || user?.badmintonTime == "未設定" ? "未設定":user?.badmintonTime
    }
    
    //Mark:updateBorder
    private func updateBorder() {
        setupBorder(view: ageStackView)
        setupBorder(view: genderStackView)
        setupBorder(view: badmintonTimeStackView)
    }
    
    //Mark:setupBorder
    private func setupBorder(view:UIView) {
        let border = CALayer()
        border.frame = CGRect(x: view.frame.width - 1, y: 15, width: 5.0, height: view.frame.height)
        border.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(border)
    }
    
    //Mark:Delegate,DataSource
    private func setupDelegate() {
        belongCollectionView.delegate = self
        belongCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        fetchData.friendDelegate = self
    }
    
    //Mark: setupCollectionViewCell
    private func setupCollection() {
        let belongsNib = TeammemberCell.nib()
        belongCollectionView.register(belongsNib, forCellWithReuseIdentifier: Utility.CellId.MemberCellId)
        let friendNib = TeammemberCell.nib()
        friendCollectionView.register(friendNib, forCellWithReuseIdentifier: "friendCEllId")
        let layout = UICollectionViewFlowLayout()
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        layout.scrollDirection = .horizontal
        friendCollectionView.collectionViewLayout = layout2
        belongCollectionView.collectionViewLayout = layout
        setupDelegate()
        getNeededMethod()
    }
    
    //Mark:setupData
    private func setupData() {
        let myId = Auth.getUserId()
        guard let user = user else { return }
        Firestore.searchFriend(friend: user, myId: myId) { result in
            if result {
                self.friendButton.backgroundColor = Utility.AppColor.OriginalBlue
                self.friendButton.setTitle("友達解除", for: UIControl.State.normal)
                self.friendButton.setTitleColor(.white, for: UIControl.State.normal)
            } else {
                self.friendButton.backgroundColor = .white
                self.friendButton.setTitle("友達申請", for: UIControl.State.normal)
                self.friendButton.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
                self.friendButton.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
                self.friendButton.layer.borderWidth = 4
            }
        }
    }
    
    //Mark:getNeededMethod
    private func getNeededMethod() {
        self.userFriend = []
        guard let memberId = user?.uid else { return }
        guard let urlString = user?.profileImageUrl else { return }
        if urlString == "" {
            teamMemberImageView.image = UIImage(named: "noImages")
        } else {
            let url = URL(string: urlString)
            teamMemberImageView.sd_setImage(with: url, completed: nil)
        }
        Firestore.getOwnTeam(uid: memberId) { teams in
            self.ownTeam = teams
            self.belongCollectionView.reloadData()
            Firestore.getFriendData(uid: memberId) { friends in
                self.fetchData.friendData(idArray: friends)
            }
        }
    }
    
//Mark:IBAction
    @IBAction func plusFriend(_ sender: Any) {
        print(#function)
        friendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        let myId = Auth.getUserId()
        guard let user = user else { return }
        if friendButton.backgroundColor == .white {
            friendButton.backgroundColor = Utility.AppColor.OriginalBlue
            self.friendButton.setTitle("友達解除", for: UIControl.State.normal)
            self.friendButton.setTitleColor(.white, for: UIControl.State.normal)
            Firestore.friendAction(myId: myId, friend: user, bool: true)
        } else {
            friendButton.backgroundColor = .white
            friendButton.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
            friendButton.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
            friendButton.layer.borderWidth = 4
            friendButton.layer.cornerRadius = 15
            friendButton.layer.masksToBounds = true
            self.friendButton.setTitle("友達申請", for: UIControl.State.normal)
            Firestore.friendAction(myId: myId, friend: user, bool: false)
        }
    }
    
    @IBAction func gotoChat(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.me = me
        vc.you = user
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func gotoDM(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            vc.me = me
            vc.you = user
            navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
  
}

//Mark: UserCollectionViewDelegate
extension UserDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == belongCollectionView && collectionView.tag == 0 {
            return ownTeam.count
        } else  {
            return userFriend.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.belongCollectionView && collectionView.tag == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.MemberCellId, for: indexPath) as! TeammemberCell
        let name = ownTeam[indexPath.row].teamName
        let urlString = ownTeam[indexPath.row].teamImageUrl
            cell.configure(name: name, urlString: urlString)
            cell.teamMemberImage.contentMode = .scaleAspectFill
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCEllId", for: indexPath) as! TeammemberCell
            let name = userFriend[indexPath.row].name
            let urlString = userFriend[indexPath.row].profileImageUrl
            cell.configure(name: name, urlString: urlString)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


extension UserDetailViewController:GetFriendDelegate {
    
    func getFriend(friendArray: [User]) {
        self.userFriend = []
        self.userFriend = friendArray
        self.friendCollectionView.reloadData()
    }
    
  
}
