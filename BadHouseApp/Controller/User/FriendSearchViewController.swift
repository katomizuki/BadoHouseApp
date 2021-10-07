import UIKit
import SDWebImage
import Firebase
import FacebookCore

class FriendSSearchViewController: UIViewController {

    //Mark:Properties
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tableView.addGestureRecognizer(gesture)
        }
    }
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = Utility.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Utility.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
        }
    }
    private let fetchData = FetchFirestoreData()
    private var friendList = [User]()
    private let cellId = Utility.CellId.searchCell
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDelegate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    
    private func setupDelegate() {
        searchBar.delegate = self
        fetchData.userDelegate = self
    }
    
   //Mark:setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendSearchCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
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
    @objc private func handleTap() {
        searchBar.resignFirstResponder()
    }
}

//Mark:UITableViewDelegate,DataSource
extension FriendSSearchViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendSearchCell
        cell.link = self
        cell.nameLabel.text = ""
        cell.nameLabel.text = friendList[indexPath.row].name
        let urlString = friendList[indexPath.row].profileImageUrl
        if urlString == "" {
            cell.iv.image = UIImage(named: Utility.ImageName.noImages)
        } else {
            if let url = URL(string: urlString) {
                cell.iv.sd_setImage(with: url, completed: nil)
            }
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
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let text = searchBar.text else { return }
        fetchData.searchFriends(text: text)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    
  
    
}

//Mark:GetUserDelegate
extension FriendSSearchViewController:GetUserDataDelegate {
    
    func getUserData(userArray: [User]) {
        print(#function)
        self.friendList = userArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
