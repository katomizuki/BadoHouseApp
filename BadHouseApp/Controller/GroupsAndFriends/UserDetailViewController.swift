

import UIKit
import Firebase
import SDWebImage


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
    
    //Mark: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setBackBarButton()
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
        
        //Mark: BorderUpdate
        let border = CALayer()
        border.frame = CGRect(x: ageStackView.frame.width - 1, y: 15, width: 5.0, height: ageStackView.frame.height - 25)
        border.backgroundColor = UIColor.lightGray.cgColor
        ageStackView.layer.addSublayer(border)
 
        
        let border2 = CALayer()
        border2.backgroundColor = UIColor.lightGray.cgColor
        border2.frame = CGRect(x:genderStackView.frame.width - 1,y:15,width: 5.0,height: genderStackView.frame.height - 25)
   
        genderStackView.layer.addSublayer(border2)
        
        
        let border3 = CALayer()
        border3.backgroundColor = UIColor.lightGray.cgColor
        border3.frame = CGRect(x:badmintonTimeStackView.frame.width - 1,y:15,width: 5.0,height: badmintonTimeStackView.frame.height - 25)
      
        badmintonTimeStackView.layer.addSublayer(border3)
        
        //Mark:UserInfo UpdateUI
        nameLabel.text = user?.name
        ageLabel.text = user?.age == "" || user?.age == nil || user?.age == "未設定" ? "未設定":user?.age
        genderLabel.text = user?.gender == "" || user?.gender == nil || user?.gender == "未設定" ? "未設定":user?.gender
        levelLabel.text = user?.level == "" || user?.level == nil || user?.level == "未設定" ? "未設定":user?.level
        badmintoTimeLabel.text = user?.badmintonTime == "" || user?.badmintonTime == nil || user?.badmintonTime == "未設定" ? "未設定":user?.badmintonTime
    
        //Mark: Delegate,Datasource
        belongCollectionView.delegate = self
        belongCollectionView.dataSource = self
        friendCollectionView.delegate = self
        friendCollectionView.dataSource = self
        
        //Mark:collectionViewCell
        let belongsNib = TeammemberCell.nib()
        belongCollectionView.register(belongsNib, forCellWithReuseIdentifier: Utility.CellId.MemberCellId)
        let friendNib = TeammemberCell.nib()
        friendCollectionView.register(friendNib, forCellWithReuseIdentifier: Utility.CellId.MemberCellId)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        friendCollectionView.collectionViewLayout = layout
        belongCollectionView.collectionViewLayout = layout
        getNeededMethod()
   
        
        //Mark: FriendButton
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
        guard let memberId = user?.uid else { return }
        guard let urlString = user?.profileImageUrl else { return }
        let url = URL(string: urlString)
        teamMemberImageView.sd_setImage(with: url, completed: nil)
        Firestore.getOwnTeam(uid: memberId) { teams in
            self.ownTeam = teams
            Firestore.getFriendData(uid: memberId) { friends in
//                self.userFriend = friends
        
                self.belongCollectionView.reloadData()
                self.friendCollectionView.reloadData()
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
    
    
    @IBAction func commentTap(_ sender: Any) {
        print(#function)
        let viewController = CommentViewController() //popoverで表示するViewController
               viewController.modalPresentationStyle = .popover
               viewController.preferredContentSize = CGSize(width: 200, height: 100)

               let presentationController = viewController.popoverPresentationController
               presentationController?.delegate = self
               presentationController?.permittedArrowDirections = .left
               presentationController?.sourceView = teamMemberImageView
               presentationController?.sourceRect = teamMemberImageView.bounds
               viewController.presentationController?.delegate = self
               viewController.introduction = user?.introduction ?? "未設定"
               present(viewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                       traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return .none
        }
    

}


//Mark: UserCollectionView
extension UserDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.belongCollectionView {
            return ownTeam.count
        } else {
            return userFriend.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.MemberCellId, for: indexPath) as! TeammemberCell
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        cell.layer.borderWidth = 4
        cell.layer.masksToBounds = true
        if collectionView == self.belongCollectionView {
      
            
        let name = ownTeam[indexPath.row].teamName
        let urlString = ownTeam[indexPath.row].teamImageUrl
            cell.configure(name: name, urlString: urlString)
            cell.teamMemberImage.contentMode = .scaleAspectFill
        } else if collectionView == self.friendCollectionView {
            let name = userFriend[indexPath.row].name
            let urlString = userFriend[indexPath.row].profileImageUrl
            cell.configure(name: name, urlString: urlString)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

  
}


