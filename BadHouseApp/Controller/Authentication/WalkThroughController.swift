import UIKit

class WalkThroughController:UIPageViewController, UIPageViewControllerDataSource  {
    
    private let firstVC:UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.logoImage)
        let label = UITextView()
        label.text = "ダウンロードしていただきありがとうございます"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.isEditable = false
        label.isSelectable = false
        let explainLabel = UITextView()
        explainLabel.text = "ログインした後にユーザー情報を更新してみてね！"
        explainLabel.font = UIFont.boldSystemFont(ofSize: 16)
        explainLabel.textColor = .darkGray
        explainLabel.isEditable = false
        explainLabel.isSelectable = false
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        vc.view.addSubview(explainLabel)
        iv.anchor(top:vc.view.topAnchor,paddingTop: 50, centerX: vc.view.centerXAnchor,width: 100,height: 100)
        label.anchor(top:iv.bottomAnchor,paddingTop: 20,centerX: vc.view.centerXAnchor,width:300,height:50)
        explainLabel.anchor(top:label.bottomAnchor,paddingTop: 10,centerX: vc.view.centerXAnchor,width:300,height: 50)
        return vc
    }()
    
    private let secondVC:UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let iv = UIImageView()
        iv.image = UIImage(named: Utility.ImageName.logoImage)
        let label = ProfileLabel(title: "早速初めてみよう！", num: 20)
        label.isHighlighted = false
        label.textColor = .darkGray
        let explainLabel = UITextView()
        explainLabel.text = "メインページでバドミントンをしたい条件や\nキーワードで開催予定の練習を探してみよう"
        explainLabel.textColor = .darkGray
        explainLabel.font = UIFont.boldSystemFont(ofSize: 16)
        explainLabel.isEditable = false
        explainLabel.isSelectable = false
        let plusLabel = UITextView()
        plusLabel.text = "参加したい練習の主催者の方にチャットを送るだけ！！"
        plusLabel.isEditable = false
        plusLabel.isSelectable = false
        plusLabel.font = UIFont.boldSystemFont(ofSize: 16)
        plusLabel.textColor = .darkGray
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        vc.view.addSubview(explainLabel)
        vc.view.addSubview(plusLabel)
        iv.anchor(top:vc.view.topAnchor,paddingTop: 50, centerX: vc.view.centerXAnchor,width: 100,height: 100)
        explainLabel.anchor(top:iv.bottomAnchor,paddingTop: 20,centerX: vc.view.centerXAnchor,width:320,height:50)
        plusLabel.anchor(top:explainLabel.bottomAnchor,paddingTop: 0,centerX: vc.view.centerXAnchor,width:350,height:40)
        label.anchor(top:plusLabel.bottomAnchor,paddingTop: 5,centerX: vc.view.centerXAnchor,width: 300,height: 40)
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
