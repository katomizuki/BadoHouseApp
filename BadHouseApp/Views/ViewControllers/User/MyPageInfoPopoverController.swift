import UIKit
import RxSwift
protocol PopDismissDelegate: AnyObject {
    func popDismiss(vc: MyPageInfoPopoverController,
                    userInfoSelection:UserInfoSelection,
                    text: String)
}
final class MyPageInfoPopoverController: UIViewController {
    // MARK: Properties
    weak var delegate: PopDismissDelegate?
    private let cellId = "popCellId"
    private var cellArray = [String]()
    var keyword: UserInfoSelection = .level
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tb
    }()
    var (age,
         place,
         badmintonTime,
         gender) = (String(), String(), String(), String())
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    // MARK: - SetupMethod
    private func setUpTableView() {
        self.view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        switch keyword {
        case UserInfoSelection.gender:
            cellArray = Gender.genderArray
        case UserInfoSelection.badmintonTime:
            cellArray = Constants.Data.yearArray
        case UserInfoSelection.place:
            cellArray = Place.placeArray
        case UserInfoSelection.age:
            cellArray = Constants.Data.ageArray
        default:
            break
        }
        tableView.reloadData()
    }
}
// MARK: - TableViewDatasource
extension MyPageInfoPopoverController: UITableViewDataSource {
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
}
// MARK: - TableViewDelegate
extension MyPageInfoPopoverController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UserPageController.init(nibName: R.nib.userPageController.name, bundle: nil)
        self.delegate?.popDismiss(vc: self,userInfoSelection: keyword,text: cellArray[indexPath.row])
    }
}
