import UIKit

class WalkThroughController: UIViewController {
    
    lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var viewControllers = [UIViewController]()
    lazy var pageControl = UIPageControl()
    private let nextButton = UIButton()
    private let images = [UIImage(named: "ウォ-ク")!,UIImage(named: "ウォ-ク")!]

    override func viewDidLoad() {
        super.viewDidLoad()
        let contentRect = CGRect(x: 40, y: 200, width: view.bounds.width - 80, height: view.bounds.width - 60)
        for index in 0..<images.count {
            view.backgroundColor = .white
            let vc = UIViewController()
            vc.view.backgroundColor = .purple
            vc.view.tag = index
            let imageView = UIImageView()
            imageView.frame.size = contentRect.size
            imageView.image = images[index]
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .white
            vc.view.addSubview(imageView)
  
            viewControllers.append(vc)
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = contentRect
              view.addSubview(pageViewController.view!)

              //Mark PageControl
              pageControl.frame = CGRect(x:0, y:view.bounds.height - 160, width:view.bounds.width, height:70)
              pageControl.pageIndicatorTintColor = .lightGray
              pageControl.currentPageIndicatorTintColor = .gray
              pageControl.numberOfPages = images.count
              pageControl.currentPage = 0
              pageControl.isUserInteractionEnabled = false
              view.addSubview(pageControl)

              //Mark NextButton
              nextButton.frame = CGRect(x: 40, y: view.bounds.size.height - 100, width: view.bounds.size.width - 80, height: 40)
              nextButton.setTitle("次へ", for: .normal)
              nextButton.layer.cornerRadius = 20
              nextButton.clipsToBounds = true
              nextButton.backgroundColor = .gray
              nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
              view.addSubview(nextButton)
       
    }
    
    //Mark: selector lastPageTapped
    @objc func nextButtonTapped() {
            print("nextButtonTapped")
        dismiss(animated: true, completion: nil)
        }
    //mark:set button enabled
    private func setNextButtonStatus(index: Int) {
            if index == images.count - 1 {
                nextButton.backgroundColor = Utility.AppColor.OriginalBlue
                nextButton.isEnabled = true
            } else {
                nextButton.backgroundColor = .gray
                nextButton.isEnabled = false
            }
        }

}
//Mark: pageController DataSource
extension WalkThroughController: UIPageViewControllerDataSource {
    
    //左にスワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        //Mark enabledButton
        setNextButtonStatus(index: index)

        if index == images.count - 1{
            return nil
        }
        //どんどん足していく
        index = index + 1
        //viewControllerを出力する
        return viewControllers[index]
    }

    //右にスワイプ
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        setNextButtonStatus(index: index)
        //どんどん引いていく。
        index = index - 1
        if index < 0{
            return nil
        }
        return viewControllers[index]
    }
}

extension WalkThroughController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {
        print("didFinishAnimating")
    }
}
