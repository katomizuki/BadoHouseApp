import UIKit
import FacebookCore

class PopViewController: UIViewController{
    
    //Mark Properties
    private let CellId = Utility.CellId.popCellId
    var cellArray = Utility.Data.genderArray
    var keyword = String()
    let tableView = UITableView()
    var (age,place,badmintonTime,gender) = (String(),String(),String(),String())
    
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    //Mark setupMethod
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor)
        switch keyword {
        case UserInfo.gender.rawValue:
            cellArray = Utility.Data.genderArray
        case UserInfo.badmintonTime.rawValue:
            cellArray = Utility.Data.yearArray
        case UserInfo.place.rawValue:
            cellArray = Utility.Data.placeArray
        case UserInfo.age.rawValue:
            cellArray = Utility.Data.ageArray
        default:
            break
        }
        tableView.reloadData()
    }
}

//Mark tableViewdelegate
extension PopViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellId, for: indexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
    
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
        dismiss(animated: true, completion: nil)
    }
}
