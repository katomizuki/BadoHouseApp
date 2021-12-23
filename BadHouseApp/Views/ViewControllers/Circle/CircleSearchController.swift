import UIKit
import CDAlertView
final class CircleSearchController: UIViewController {
    // MARK: - properties
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = .none
            searchBar.placeholder = "場所名,サークル名等,検索"
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    private var groupArray = [TeamModel]()
    var friends = [User]()
    private let cellId = "cellGroupId"
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapRightButtonItem))
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        let nib = TalkCell.nib()
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - SelectorMethod
    @objc private func didTapRightButtonItem() {
//        let vc = SearchDetailGroupController()
//        let nav = UINavigationController(rootViewController: vc)
//        vc.delegate = self
//        present(nav, animated: true, completion: nil)
    }
}
// MARK: - tableViewDataSource
extension CircleSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TalkCell
        let team = groupArray[indexPath.row]
        cell.team = team
        return cell
    }
}
// MARK: - uitableViewDelegate
extension CircleSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let team = groupArray[indexPath.row]
        let controller = CircleDetailController.init(nibName: "CircleDetailController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK: - SearchBarDelegate
extension CircleSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
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
    }
}


//extension CircleSearchController: SearchDetailGroupDelegate {
//    func seachDetailGroup(vc: SearchDetailGroupController, time: String, money: String, place: String) {
//        vc.dismiss(animated: true, completion: nil)
//    }
//    func dismissGroupVC(vc: SearchDetailGroupController) {
//        vc.dismiss(animated: true, completion: nil)
//    }
//}
