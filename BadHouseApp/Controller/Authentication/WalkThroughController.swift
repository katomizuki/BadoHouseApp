import UIKit

class WalkThroughController:UIPageViewController, UIPageViewControllerDataSource  {
    
    private let firstVC:UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.logoImage)
        let label = ProfileLabel(title: "ダウンロードありがとうございます", num: 20)
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        iv.anchor(top:vc.view.topAnchor,paddingTop: 50, centerX: vc.view.centerXAnchor,width: 100,height: 100)
        label.anchor(top:iv.bottomAnchor,paddingTop: 20,centerX: vc.view.centerXAnchor,width:300,height:40)
        return vc
    }()
    
    private let secondVC:UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.logoImage)
        let label = ProfileLabel(title: "よろしくお願いします", num: 20)
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        iv.anchor(top:vc.view.topAnchor,paddingTop: 50, centerX: vc.view.centerXAnchor,width: 100,height: 100)
        label.anchor(top:iv.bottomAnchor,paddingTop: 20,centerX: vc.view.centerXAnchor,width:200,height:40)
        return vc
    }()
    
    private lazy var pages:[UIViewController] = {
        let views = [firstVC,secondVC]
        return views
    }()
    private var pageControl:UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        let width = self.view.frame.maxX
        pageControl = UIPageControl(frame: CGRect(x:0, y:self.view.frame.maxY - 100, width:width, height:50))
        pageControl.backgroundColor = Utility.AppColor.OriginalBlue
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController), pageIndex - 1 >= 0 {
            pageControl.currentPage = 0
            return pages[pageIndex - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController), pageIndex + 1 < pages.count {
            pageControl.currentPage = 1
            return pages[pageIndex + 1]
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
