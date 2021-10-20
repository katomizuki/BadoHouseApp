import UIKit
import EmptyStateKit
import CDAlertView

class GroupSearchController: UIViewController {
    // Mark properties
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.tintColor = Constants.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Constants.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
            searchBar.placeholder = "場所名,サークル名等,検索"
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    private let fetchData = FetchFirestoreData()
    private var groupArray = [TeamModel]()
    var friends = [User]()
    // Mark LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        fetchData.groupSearchDelegate = self
        setupEmptyState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // Mark setupMethod
    private func setupTableView() {
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Constants.CellId.CellGroupId)
        tableView.delegate = self
        tableView.dataSource = self
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
        format.backgroundColor = UIColor(named: Constants.AppColor.darkColor) ?? .systemGray
        view.emptyState.format = format
    }
}
// Mark tableViewDataSource
extension GroupSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.CellGroupId, for: indexPath) as! GroupCell
        let team = groupArray[indexPath.row]
        cell.team = team
        return cell
    }
}
// Mark uitableViewDelegate
extension GroupSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let team = groupArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupDetailVC) as! GroupDetailController
        vc.team = team
        vc.friends = friends
        vc.flag = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
// Mark searchBarDelegate
extension GroupSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        fetchData.searchGroupData(text: text, bool: false)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print(#function)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        return true
    }
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
        searchBar.text = ""
        fetchData.searchGroupData(text: text, bool: true)
    }
}
// Mark getGroupDelegate
extension GroupSearchController: FetchSearchGroupDelegate {
    func fetchSearchGroup(groupArray: [TeamModel], bool: Bool) {
        if bool == false {
            self.groupArray = groupArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else if bool == true {
            if groupArray.isEmpty {
                view.emptyState.show(State.noSearch)
            } else {
                self.groupArray = groupArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
// Mark EmptyStateDelegate
extension GroupSearchController: EmptyStateDelegate {
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
    }
}
