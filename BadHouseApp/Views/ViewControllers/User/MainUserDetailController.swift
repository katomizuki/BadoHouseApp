
import UIKit

 final class MainUserDetailController: UIViewController {
    // MARK: - Properties
    var flag = false

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonDisplayMode = .minimal
    }
  
    // MARK: - Selector
    // MARK: - IBAction
   
}
