import UIKit
import SDWebImage
import Firebase
import CDAlertView
import RxSwift
import RxCocoa

final class AccountSearchController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    private var friendList = [User]()
    private let cellId = "searchCell"
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let disposeBag = DisposeBag()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDelegate()
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
        setupBinding()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // MARK: - SetupMethod
    private func setupDelegate() {
        searchBar.delegate = self
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FriendSearchCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
    }
    // MARK: - CustomDelegate
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
    // MARK: - SelectorMethod
    @objc private func back() {
        dismiss(animated: true, completion: nil)
    }
    private func setupBinding() {
        UserService().getUserData().subscribe { result in
            switch result {
            case .success(let users): print(users)
            case .failure(let error): print(error)
            }
        }.disposed(by: disposeBag)
    }
}
// MARK: - TableViewDataSource
extension AccountSearchController: UITableViewDataSource {
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
// MARK: - TableViewDelegate
extension AccountSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
}
// MARK: SearchBarDelegate
extension AccountSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            self.setupCDAlert(title: "検索エラー",
                              message: "１文字以上入力してください",
                              action: "OK",
                              alertType: CDAlertViewType.error)
            return
        }
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let text = searchBar.text else { return }
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


