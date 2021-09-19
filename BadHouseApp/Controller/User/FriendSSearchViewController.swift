import UIKit
import SDWebImage
import Firebase

class FriendSSearchViewController: UIViewController {

    //Mark:Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let fetchData = FetchFirestoreData()
    private var friendList = [User]()
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        fetchData.userDelegate = self
    }
    
   //Mark:setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendSearchCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    func method(cell:UITableViewCell) {
        print(#function)
        let indexPathTapped = tableView.indexPath(for: cell)
        guard let index = indexPathTapped?[1] else { return }
        let friend = friendList[index]
        //自分の友だちにいるかチェックする
        Firestore.searchFriend(friend: friend, myId: Auth.getUserId()) { bool in
            if bool == false {
                Firestore.friendAction(myId: Auth.getUserId(), friend: friend, bool: true)
            }
        }
    }
}

//Mark:UITableViewDelegate,DataSource
extension FriendSSearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! FriendSearchCell
        cell.link = self
        cell.nameLabel.text = friendList[indexPath.row].name
        cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        let urlString = friendList[indexPath.row].profileImageUrl
        if let url = URL(string: urlString) {
            cell.iv.sd_setImage(with: url, completed: nil)
            cell.iv.layer.cornerRadius = 25
            cell.iv.layer.masksToBounds = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}

//Mark:UISearchDelegate
extension FriendSSearchViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        guard let text = searchBar.text else { return }
        fetchData.searchFriends(text: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let text = searchBar.text else { return }
        fetchData.searchFriends(text: text)
    }
    
}

//Mark:GetUserDelegate
extension FriendSSearchViewController:GetUserDataDelegate {
    
    func getUserData(userArray: [User]) {
        print(#function)
        print(userArray)
        self.friendList = userArray
        tableView.reloadData()
    }
}