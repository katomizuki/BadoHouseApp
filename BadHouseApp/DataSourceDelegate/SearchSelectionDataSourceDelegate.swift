import UIKit
protocol SearchSelectionDataSourceDelegateProtocol: AnyObject {
    func searchSelectionDataSourceDelegate(_ text: String)
}
final class SearchSelectionDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var cellArray = [String]()
    weak var delegate: SearchSelectionDataSourceDelegateProtocol?
    private let cellId = "popCellId"
    
    func initCellArray(_ array: [String]) {
        self.cellArray = array
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedString = cellArray[indexPath.row]
        self.delegate?.searchSelectionDataSourceDelegate(selectedString)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
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
