import UIKit
import Firebase
import SDWebImage
import XLPagerTabStrip

class PreJoinViewController: ButtonBarPagerTabStripViewController{
    
    //Mark properties
    lazy var collectionView:ButtonBarView = {
        let cv = buttonBarView
        return cv!
    }()
    
    lazy var scrollView:UIScrollView = {
        let sv = containerView
        return sv!
    }()
    
    //Mark lifecycle
    override func viewDidLoad() {
        setupXLTab()
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(scrollView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionAndScroll()
       
    }
    
    private func collectionAndScroll() {
        let width = view.frame.size.width
        let height = view.frame.size.height

        collectionView.frame = CGRect(x: 0, y: 50, width: width, height: 64)
        scrollView.frame = CGRect(x: 0, y: 50 + 64, width: width, height: height - 64)
        
        collectionView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 50,paddingRight: 0, paddingLeft: 0,height: 70)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    private func setupXLTab() {
        settings.style.buttonBarItemBackgroundColor = UIColor(named: Utility.AppColor.darkColor)
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.buttonBarBackgroundColor = UIColor(named: Utility.AppColor.darkColor)
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
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First") as! ChildViewController
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second") as! DaughterViewController
        return [firstVC,secondVC]
    }
    
    
}





