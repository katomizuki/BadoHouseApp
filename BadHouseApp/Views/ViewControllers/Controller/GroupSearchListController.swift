import UIKit
protocol GroupSearchListDelegate: AnyObject {
    func didTapMoneyList(seletedMoney: String)
    func didTapDayList(selectedDay: String)
    func didTapPlaceList(selectedPlace: String)
}
final class GroupSearchListController: UIViewController {
    // MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    private let moneyArray = Constants.Data.moneyArray
    private let dayArray = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
    var judgeListKeyword: String?
    weak var delegate: GroupSearchListDelegate?
    // MARK: - LifeCylcle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20,
                         paddingBottom: 10,
                         paddingRight: 20,
                         paddingLeft: 20)
    }
}
// MARK: - UITableViewDelegate-Extension
extension GroupSearchListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch judgeListKeyword {
        case "day":
            let day = dayArray[indexPath.row]
            self.delegate?.didTapDayList(selectedDay: day)
        case "money":
            let money = moneyArray[indexPath.row]
            self.delegate?.didTapMoneyList(seletedMoney: money)
        case "place":
            guard let text = Place(rawValue: indexPath.row)?.name else { return }
            self.delegate?.didTapPlaceList(selectedPlace: text)
        default:break
        }
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - UITableViewDatasource-Extension
extension GroupSearchListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        switch judgeListKeyword {
        case "day":
            cell.textLabel?.text = dayArray[indexPath.row]
        case "money":
            cell.textLabel?.text = moneyArray[indexPath.row]
        case "place" :
            guard let text = Place(rawValue: indexPath.row)?.name else { return cell }
            cell.textLabel?.text = text
        default:break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch judgeListKeyword {
        case "day": return dayArray.count
        case "money": return moneyArray.count
        case "place" : return Place.allCases.count
        default:break
        }
        return 0
    }
}
