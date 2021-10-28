import UIKit
import FacebookCore
protocol PopDismissDelegate: AnyObject {
    func popDismiss(vc: MyPageInfoPopoverController)
}
final class MyPageInfoPopoverController: UIViewController {
    // MARK: Properties
    weak var delegate: PopDismissDelegate?
    private let cellId = Constants.CellId.popCellId
    var cellArray = Gender.genderArray
    var keyword = String()
    lazy var tableView: UITableView = {
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
                         left: view.leftAnchor,
                         right: view.rightAnchor)
        switch keyword {
        case UserInfo.gender:
            cellArray = Gender.genderArray
        case UserInfo.badmintonTime:
            cellArray = Constants.Data.yearArray
        case UserInfo.place:
            cellArray = Place.placeArray
        case UserInfo.age:
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
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
}
// MARK: - TableViewDelegate
extension MyPageInfoPopoverController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.presentingViewController as! MyPageUserInfoController
        switch keyword {
        case UserInfo.gender:
            gender = cellArray[indexPath.row]
            vc.gender = self.gender
        case UserInfo.badmintonTime:
            badmintonTime = cellArray[indexPath.row]
            vc.badmintonTime = self.badmintonTime
        case UserInfo.place:
            place = cellArray[indexPath.row]
            vc.place = self.place
        case UserInfo.age:
            age = cellArray[indexPath.row]
            vc.age = self.age
        default:
            break
        }
        self.delegate?.popDismiss(vc: self)
    }
}
