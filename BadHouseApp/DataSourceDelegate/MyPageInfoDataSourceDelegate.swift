import UIKit
protocol MyPageInfoDataSourceDelegateProtocol: AnyObject {
    func myPageInfoDataSourceDelegate(_ text: String)
}
class MyPageInfoDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellId = "popCellId"
    weak var delegate:MyPageInfoDataSourceDelegateProtocol?
    private var cellArray = [String]()
    
    func initArray(_ array:[String]) {
        self.cellArray = array
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = cellArray[indexPath.row]
        cell.contentConfiguration = configuration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.myPageInfoDataSourceDelegate(cellArray[indexPath.row])
    }
}
