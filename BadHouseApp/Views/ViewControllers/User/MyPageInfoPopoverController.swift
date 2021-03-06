import UIKit
import RxSwift
// swiftlint:disable weak_delegate
protocol PopDismissDelegate: AnyObject {
    func popDismiss(vc: MyPageInfoPopoverController,
                    userInfoSelection: UserInfoSelection,
                    text: String)
}

final class MyPageInfoPopoverController: UIViewController {
    // MARK: Properties
   
    private let dataSourceDelegate = MyPageInfoDataSourceDelegate()
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.delegate = dataSourceDelegate
        tb.dataSource = dataSourceDelegate
        tb.separatorStyle = .none
        tb.register(UITableViewCell.self, forCellReuseIdentifier: R.cellId)
        return tb
    }()
    
    weak var delegate: PopDismissDelegate?
    var keyword: UserInfoSelection = .level
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

extension MyPageInfoPopoverController: MyPageInfoDataSourceDelegateProtocol {
    func myPageInfoDataSourceDelegate(_ text: String) {
        self.delegate?.popDismiss(vc: self, userInfoSelection: keyword, text: text)
    }
}
