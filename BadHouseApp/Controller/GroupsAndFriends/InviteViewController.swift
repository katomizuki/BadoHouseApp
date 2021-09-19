import UIKit
import Firebase

class InviteViewController: UIViewController {

    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var friends = [User]()
    var inviter = [User]()
    var team: TeamModel?
    private var cellId = Utility.CellId.inviteCellId

    //Mark CustomDelegate
    func someMethodWantToCall(cell:UITableViewCell) {
        print(#function)
        let indexPathTapped = tableView.indexPath(for: cell)
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
    
    //Mark: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        inviteButton.layer.cornerRadius = 15
        inviteButton.layer.masksToBounds = true
    }
    
    
    
    //Mark setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendsCell.self, forCellReuseIdentifier: cellId)
    }
    
    //Mark:IBAction
    @IBAction func invite(_ sender: Any) {
        print(#function)
        guard let team = self.team else { return }
        Firestore.sendInvite(team: team, inviter: self.inviter)
        
        dismiss(animated: true, completion: nil)
    }
    

}

//Mark:tableViewdelegate,datsource
extension InviteViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! FriendsCell
        cell.linkInvite = self
        cell.textLabel?.text = friends[indexPath.row].name
        let urlString = friends[indexPath.row].profileImageUrl
        let url = URL(string: urlString)
        if urlString == "" {
            cell.imageView?.image = UIImage(named: Utility.ImageName.swift)
            cell.imageView?.layer.cornerRadius = 30
            cell.imageView?.layer.masksToBounds = true
        } else {
            cell.imageView?.sd_setImage(with: url, completed: nil)
            cell.imageView?.layer.cornerRadius = 30
            cell.imageView?.layer.masksToBounds = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
