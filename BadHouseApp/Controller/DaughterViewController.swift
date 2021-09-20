import UIKit
import XLPagerTabStrip

class DaughterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}

extension DaughterViewController:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "参加予定者")
    }
}
