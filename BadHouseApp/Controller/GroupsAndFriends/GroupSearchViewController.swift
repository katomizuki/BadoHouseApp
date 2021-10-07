import UIKit

class GroupSearchViewController: UIViewController {

    //Mark:properties
    @IBOutlet private weak var searchBar: UISearchBar!{
        didSet {
            searchBar.tintColor = Utility.AppColor.OriginalBlue
            searchBar.showsCancelButton = true
            searchBar.backgroundColor = Utility.AppColor.OriginalBlue
            searchBar.autocapitalizationType = .none
            searchBar.placeholder = "場所名,サークル名等,検索"
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tableView.addGestureRecognizer(gesture)
        }
    }
    private let fetchData = FetchFirestoreData()
    private var groupArray = [TeamModel]()
    var friends = [User]()
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        fetchData.groupSearchDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        searchBar.resignFirstResponder()
    }
    
    //Mark helperMethod
    private func setupTableView() {
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //Mark selector
    @objc private func handleTap() {
        searchBar.resignFirstResponder()
    }
    
   
  

}
//Mark tableViewDelegate
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
        let team = groupArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupDetailVC) as! GroupDetailViewController
        vc.team = team
        vc.friends = friends
        vc.flag = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
//Mark searchBarDelegate
extension GroupSearchViewController:UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        fetchData.searchGroup(text: text)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
    }
  
}

extension GroupSearchViewController:GetGroupDelegate{
    
    func getGroup(groupArray: [TeamModel]) {
        self.groupArray = groupArray
        tableView.reloadData()
    }
}
