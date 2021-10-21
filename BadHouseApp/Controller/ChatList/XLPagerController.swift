import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip
enum XLPager: String {
    case main = "Main"
    case first = "First"
    case second = "Second"
}
class XLPagerController: ButtonBarPagerTabStripViewController {
    // Mark properties
    lazy var collectionView: ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    lazy var scrollView: UIScrollView = {
        let sv = containerView
        return sv!
    }()
    // Mark lifecycle
    override func viewDidLoad() {
        setupXLTab()
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionAndScroll()
    }
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(scrollView)
    }
    // Mark helperMethod
    private func collectionAndScroll() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        collectionView.frame = CGRect(x: 0,
                                      y: 50,
                                      width: width,
                                      height: 64)
        scrollView.frame = CGRect(x: 0,
                                  y: 50 + 64,
                                  width: width,
                                  height: height - 64)
        collectionView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 50,
                              paddingRight: 0,
                              paddingLeft: 0,
                              height: 70)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    // Mark setupMethod
    private func setupXLTab() {
        settings.style.buttonBarItemBackgroundColor = UIColor(named: Constants.AppColor.darkColor)
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.buttonBarBackgroundColor = UIColor(named: Constants.AppColor.darkColor)
        settings.style.selectedBarBackgroundColor = Constants.AppColor.OriginalBlue
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 8.0
        settings.style.buttonBarLeftContentInset = 10.0
        settings.style.buttonBarRightContentInset = 10.0
        changeCurrentIndexProgressive = { oldCell, newCell, _, changeCurrentIndex, _ in
            guard changeCurrentIndex, let oldCell = oldCell, let newCell = newCell else { return }
            oldCell.label.textColor = .lightGray
            newCell.label.textColor = .darkGray
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: XLPager.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: XLPager.first.rawValue) as! CheckPreJoinController
        let secondVC = UIStoryboard(name: XLPager.main.rawValue, bundle: nil).instantiateViewController(withIdentifier: XLPager.second.rawValue) as! CheckJoinController
        return [firstVC, secondVC]
    }
}
