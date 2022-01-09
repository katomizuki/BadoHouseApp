import UIKit
import RxSwift
protocol PopDismissDelegate: AnyObject {
    func popDismiss(vc: MyPageInfoPopoverController,
                    userInfoSelection: UserInfoSelection,
                    text: String)
}
final class MyPageInfoPopoverController: UIViewController {
    // MARK: Properties
    weak var delegate: PopDismissDelegate?
    private let cellId = "popCellId"
    var keyword: UserInfoSelection = .level
    private let dataSourceDelegate = MyPageInfoDataSourceDelegate()
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
        dataSourceDelegate.delegate = self
        switch keyword {
        case UserInfoSelection.gender:
            dataSourceDelegate.initArray(Gender.genderArray)
        case UserInfoSelection.badmintonTime:
            dataSourceDelegate.initArray(R.array.yearArray)
        case UserInfoSelection.place:
            dataSourceDelegate.initArray(Place.placeArray)
        case UserInfoSelection.age:
            dataSourceDelegate.initArray(R.array.ageArray)
        default:
            break
        }
        tableView.reloadData()
    }
}
extension MyPageInfoPopoverController:MyPageInfoDataSourceDelegateProtocol {
    func myPageInfoDataSourceDelegate(_ text: String) {
        self.delegate?.popDismiss(vc: self, userInfoSelection: keyword, text: text)
    }
}
