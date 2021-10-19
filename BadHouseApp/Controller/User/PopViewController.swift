import UIKit
import FacebookCore
protocol PopDismissDelegate:AnyObject {
    func popDismiss(vc:PopViewController)
}
class PopViewController: UIViewController{
    //Mark Properties
    weak var delegate:PopDismissDelegate?
    private let CellId = Constants.CellId.popCellId
    var cellArray = Constants.Data.genderArray
    var keyword = String()
    lazy var tableView:UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .none
        tb.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        return tb
    }()
    var (age,place,badmintonTime,gender) = (String(),String(),String(),String())
    
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    //Mark setupMethod
    private func setUpTableView() {
        self.view.addSubview(tableView)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor)
        switch keyword {
        case UserInfo.gender.rawValue:
            cellArray = Constants.Data.genderArray
        case UserInfo.badmintonTime.rawValue:
            cellArray = Constants.Data.yearArray
        case UserInfo.place.rawValue:
            cellArray = Constants.Data.placeArray
        case UserInfo.age.rawValue:
            cellArray = Constants.Data.ageArray
        default:
            break
        }
        tableView.reloadData()
    }
}
//Mark tableViewDataSource
extension PopViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
}
//Mark tableViewDelegate
extension PopViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.presentingViewController as! UserViewController
        switch keyword {
        case UserInfo.gender.rawValue:
            gender = cellArray[indexPath.row]
            vc.gender = self.gender
        case UserInfo.badmintonTime.rawValue:
            badmintonTime = cellArray[indexPath.row]
            vc.badmintonTime = self.badmintonTime
        case UserInfo.place.rawValue:
            place = cellArray[indexPath.row]
            vc.place = self.place
        case UserInfo.age.rawValue:
            age = cellArray[indexPath.row]
            vc.age = self.age
        default:
            break
        }
        self.delegate?.popDismiss(vc:self)
    }
}
