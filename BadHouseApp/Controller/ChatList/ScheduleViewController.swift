
import UIKit

class ScheduleViewController: UIViewController {
    var me:User?
    
    private let tableview:UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .orange
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableview)
        tableview.anchor(top:view.safeAreaLayoutGuide.topAnchor,left:view.leftAnchor,right:view.rightAnchor,paddingTop: 40,paddingRight:0, paddingLeft: 0)
    }
    init(user:User) {
        super.init(nibName: nil, bundle: nil)
        self.me = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
