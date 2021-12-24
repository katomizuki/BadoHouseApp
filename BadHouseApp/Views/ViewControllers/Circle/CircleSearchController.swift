import UIKit
import CDAlertView
protocol CircleSearchFlow {
    func toCircleDetail()
}
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
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}
// MARK: - tableViewDataSource
extension CircleSearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as?  CustomCell else { fatalError() }
        return cell
    }
}
// MARK: - uitableViewDelegate
extension CircleSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let controller = CircleDetailController.init(nibName: R.nib.circleDetailController.name, bundle: nil)
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
            self.showCDAlert(title: "検索エラー",
                              message: "１文字以上入力してください",
                              action: "OK",
                              alertType: CDAlertViewType.error)
            return
        }
        searchBar.text = ""
    }
   
}
