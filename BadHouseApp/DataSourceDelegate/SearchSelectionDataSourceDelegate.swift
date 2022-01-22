import UIKit

protocol SearchSelectionDataSourceDelegateProtocol: NSObjectProtocol {
    func searchSelectionDataSourceDelegate(_ text: String)
}

 class SearchSelectionDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var cellArray = [String]()
    weak var delegate: SearchSelectionDataSourceDelegateProtocol?
    
    func initCellArray(_ array: [String]) {
        self.cellArray = array
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedString = cellArray[indexPath.row]
        self.delegate?.searchSelectionDataSourceDelegate(selectedString)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = cellArray[indexPath.row]
        cell.contentConfiguration = configuration
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
}
