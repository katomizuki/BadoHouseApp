import UIKit
import FacebookCore

class PopViewController: UIViewController{
    
    private let CellId = Utility.CellId.popCellId
    var cellArray = Utility.Data.genderArray
    var keyword = String()
    let tableView = UITableView()
    var gender = String()
    var badmintonTime = String()
    var age = String()
    var place = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellId)
        tableView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor)
        if keyword == "性別" {
            cellArray = Utility.Data.genderArray
        } else if keyword == "バドミントン歴" {
            cellArray = Utility.Data.yearArray
        } else if keyword == "居住地"  {
            cellArray = Utility.Data.placeArray
        } else if keyword == "年代" {
            cellArray = Utility.Data.ageArray
        }
        tableView.reloadData()
    }
}

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
        if keyword == "性別" {
            gender = cellArray[indexPath.row]
            vc.gender = self.gender
        } else if keyword == "バドミントン歴" {
            badmintonTime = cellArray[indexPath.row]
            vc.badmintonTime = self.badmintonTime
        } else if keyword == "居住地"  {
            place = cellArray[indexPath.row]
            vc.place = self.place
        } else if keyword == "年代" {
            age = cellArray[indexPath.row]
            vc.age = self.age
        }
        dismiss(animated: true, completion: nil)
    }
}
