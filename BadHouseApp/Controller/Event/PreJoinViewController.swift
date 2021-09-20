import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip

class PreJoinViewController: ButtonBarPagerTabStripViewController{
    
    lazy var collectionView:ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = containerView
        return sv!
    }()
    
    override func viewDidLoad() {
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.buttonBarBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = Utility.AppColor.OriginalBlue
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 8.0
        settings.style.buttonBarLeftContentInset = 10.0
        settings.style.buttonBarRightContentInset = 10.0
        changeCurrentIndexProgressive = { oldCell, newCell, progressPercentage, changeCurrentIndex, animated in
            guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
                oldCell.label.textColor = .lightGray
                newCell.label.textColor = .darkGray
            }
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(scrollView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        // Tab Bar
        collectionView.frame = CGRect(x: 0, y: 50, width: width, height: 64)
        
        // View Controller 表示部
        scrollView.frame = CGRect(x: 0, y: 50 + 64, width: width, height: height - 64)
        
        collectionView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 50,paddingRight: 0, paddingLeft: 0,height: 70)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First") as! ChildViewController
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second") as! DaughterViewController
        return [firstVC,secondVC]
    }
    
    
}




//import UIKit
//import Firebase
//import SDWebImage
//import AMPagerTabs
//
//class PreJoinViewController: UIViewController{
//
//    private var eventArray = [Event]()
//    private let fetchData = FetchFirestoreData()
//    @IBOutlet weak var tableView: UITableView!
//    private var notificationArray = [User]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupData()
//       setupTableView()
//
//
//    }
//
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        let nib = GroupCell.nib()
//        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
//    }
//
//    private func setupData() {
//        fetchData.preDelegate = self
//        Firestore.getmyEventId { event in
//            self.eventArray = event
//            self.fetchData.getEventPreJoinData(eventArray: event)
//        }
//    }
//
//
//}
//
//extension PreJoinViewController:GetPrejoinDataDelegate {
//    func getPrejoin(preJoin: [String]) {
//
//        for i in 0..<preJoin.count {
//            let id = preJoin[i]
//            Firestore.getUserData(uid: id) { user in
//                guard let user = user else { return }
//                self.notificationArray.append(user)
//            }
//        }
//    }
//}
//
//extension PreJoinViewController:UITableViewDelegate,UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return notificationArray.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.CellId.CellGroupId,for: indexPath) as! GroupCell
//        cell.label.text = notificationArray[indexPath.row].name
//        let urlString = notificationArray[indexPath.row].profileImageUrl
//        let url = URL(string: urlString)
//        cell.cellImagevView.sd_setImage(with: url, completed: nil)
//        return cell
//    }
//
//
//}
