import UIKit
protocol SearchSelectionControllerDelegate: AnyObject {
    func searchSelectionControllerDismiss(vc: SearchSelectionController,
                                          selection: SearchSelection,
                                          text: String)
}
class SearchSelectionController: UIViewController {
    private let cellId = "popCellId"
    private var cellArray = [String]()
    var keyWord: SearchSelection = .level
    weak var delegate: SearchSelectionControllerDelegate?
    private weak var dataSourceDelegate = SearchSelectionDataSourceDelegate()
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = dataSourceDelegate
        tb.dataSource = dataSourceDelegate
        tb.separatorStyle = .none
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tb
    }()
    var (age,
         place,
         badmintonTime,
         gender) = (String(), String(), String(), String())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView() {
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        dataSourceDelegate?.delegate = self
        switch keyWord {
        case .place:
            dataSourceDelegate?.initCellArray(Place.placeArray)
            cellArray = Place.placeArray
        case .level:
            dataSourceDelegate?.initCellArray(BadmintonLevel.level)
            cellArray = BadmintonLevel.level
            }
        tableView.reloadData()
    }
}
extension SearchSelectionController: SearchSelectionDataSourceDelegateProtocol {
    func searchSelectionDataSourceDelegate(_ text: String) {
        self.delegate?.searchSelectionControllerDismiss(vc: self, selection: keyWord, text: text)
    }
}
