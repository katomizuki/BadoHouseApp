import UIKit

class GroupSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let fetchData = FetchFirestoreData()
    private var groupArray = [TeamModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        searchBar.placeholder = "場所名,サークル名等,フリワード検索"
        fetchData.groupSearchDelegate = self
    }
    
    private func setupTableView() {
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
        tableView.delegate = self
        tableView.dataSource = self
    }
  

}

extension GroupSearchViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.CellId.CellGroupId, for: indexPath) as! GroupCell
        let team = groupArray[indexPath.row]
        cell.team = team
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groupArray[indexPath.row])
        
    }
    
    
}

extension GroupSearchViewController:UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        fetchData.searchGroup(text: text)
    }
  
}

extension GroupSearchViewController:GetGroupDelegate{
    
    func getGroup(groupArray: [TeamModel]) {
        self.groupArray = groupArray
        tableView.reloadData()
    }
    
    
}
