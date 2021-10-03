import UIKit

class ScheduleViewController: UIViewController {
    
    var me:User?
    private let cellId = "ScheduleId"
    private let fetchData = FetchFirestoreData()
    
    private let tableview:UITableView = {
        let tv = UITableView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.anchor(top:view.safeAreaLayoutGuide.topAnchor,bottom:view.safeAreaLayoutGuide.bottomAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 40,paddingBottom:0, paddingRight:0, paddingLeft: 0)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    init(user:User) {
        super.init(nibName: nil, bundle: nil)
        self.me = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}

extension ScheduleViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("🐶")
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .orange
        print("⚡")
        return cell
    }
    
    
    
}
