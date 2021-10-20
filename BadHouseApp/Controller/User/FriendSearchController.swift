import UIKit
import SDWebImage
import Firebase
import FacebookCore
import EmptyStateKit
import CDAlertView

class FriendSearchController: UIViewController {
    // Mark Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = Constants.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Constants.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
        }
    }
    private let fetchData = FetchFirestoreData()
    private var friendList = [User]()
    private let cellId = Constants.CellId.searchCell
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDelegate()
        setupEmptyState()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // Mark setupMethod
    private func setupDelegate() {
        searchBar.delegate = self
        fetchData.userSearchDelegate = self
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendSearchCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    private func setupEmptyState() {
        view.emptyState.delegate = self
        var format = EmptyStateFormat()
        format.buttonColor = Constants.AppColor.OriginalBlue
        format.buttonWidth = 200
        format.titleAttributes = [.foregroundColor: Constants.AppColor.OriginalBlue]
        format.descriptionAttributes = [.strokeWidth: -5, .foregroundColor: UIColor.darkGray]
        format.animation = EmptyStateAnimation.scale(0.3, 2.0)
        format.imageSize = CGSize(width: 200, height: 200)
        format.backgroundColor = UIColor(named: Constants.AppColor.darkColor) ?? UIColor.systemGray
        view.emptyState.format = format
    }
    // Mark CustomDelegate
    func plusFriend(cell: UITableViewCell) {
        print(#function)
        let indexPathTapped = tableView.indexPath(for: cell)
        guard let index = indexPathTapped?[1] else { return }
        let friend = friendList[index]
        UserService.searchFriend(friend: friend, myId: AuthService.getUserId()) { bool in
            if bool == false {
                UserService.friendAction(myId: AuthService.getUserId(), friend: friend, bool: true)
            }
        }
    }
}
// Mark UITableDataSource
extension FriendSearchController: UITableViewDataSource {
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
            cell.iv.image = UIImage(named: Constants.ImageName.noImages)
        } else {
            if let url = URL(string: urlString) {
                cell.iv.sd_setImage(with: url, completed: nil)
            }
        }
        return cell
    }
}
// Mark UITableViewdelegate
extension FriendSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
// Mark UISearchDelegate
extension FriendSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            self.setupCDAlert(title: "検索エラー", message: "１文字以上入力してください", action: "OK", alertType: CDAlertViewType.error)
            return
        }
        fetchData.searchFriends(text: text, bool: true)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let text = searchBar.text else { return }
        fetchData.searchFriends(text: text, bool: false)
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print(#function)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
// Mark GetUserDelegate
extension FriendSearchController: FetchSearchUserDataDelegate {
    func fetchSearchUser(userArray: [User], bool: Bool) {
        print(#function)
        if bool == false {
            self.friendList = userArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if bool == true {
            if userArray.isEmpty {
                self.view.emptyState.show(State.noSearch)
            } else {
                self.friendList = userArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
// Mark EmptyStateDelegate
extension FriendSearchController: EmptyStateDelegate {
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
    }
}
