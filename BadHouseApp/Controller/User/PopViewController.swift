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
    
    //Mark setupTableView
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor)
        switch keyword {
        case "性別":
            cellArray = Utility.Data.genderArray
        case "バドミントン歴":
            cellArray = Utility.Data.yearArray
        case "居住地":
            cellArray = Utility.Data.placeArray
        case "年代":
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
        case "性別":
            gender = cellArray[indexPath.row]
            vc.gender = self.gender
        case "バドミントン歴":
            badmintonTime = cellArray[indexPath.row]
            vc.badmintonTime = self.badmintonTime
        case "居住地":
            place = cellArray[indexPath.row]
            vc.place = self.place
        case "年代":
            age = cellArray[indexPath.row]
            vc.age = self.age
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
}
