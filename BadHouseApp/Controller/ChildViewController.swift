import UIKit
import XLPagerTabStrip

class ChildViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    

    
}
extension ChildViewController:IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "承認待ち")
    }
}
