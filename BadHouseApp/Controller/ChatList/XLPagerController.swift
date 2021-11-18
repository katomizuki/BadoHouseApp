import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip
// MARK: - XLpagerEnum
enum XLPager: String {
    case main = "Main"
    case first = "First"
    case second = "Second"
}
final class XLPagerController: ButtonBarPagerTabStripViewController {
    // MARK: - Properties
    private lazy var collectionView: ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    private lazy var scrollView: UIScrollView = {
        let sv = containerView
        return sv!
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        setupXLTab()
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionAndScroll()
    }
    // MARK: - SetupMethod
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
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(scrollView)
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,
                           left: view.leftAnchor,
                           paddingTop: 15,
                           paddingLeft: 15,
                           width: 35,
                           height: 35)
    }
    // MARK: - HelperMethod
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
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: "XLPager", bundle: nil).instantiateViewController(withIdentifier: XLPager.first.rawValue) as! CheckPreJoinController
        let secondVC = UIStoryboard(name: "XLPager", bundle: nil).instantiateViewController(withIdentifier: XLPager.second.rawValue) as! CheckJoinController
        return [firstVC, secondVC]
    }
    // MARK: - SelectorMethod
    @objc private func back() {
        dismiss(animated: true)
    }
}
