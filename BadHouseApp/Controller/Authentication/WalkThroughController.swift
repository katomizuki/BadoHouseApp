import UIKit
import FacebookCore

class WalkThroughController: UIPageViewController {
    // MARK: - FirstVC
    private let firstVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
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
        let explainImage = UIImageView()
        let imagePlusLabel = ProfileLabel(title: "マイページから↓", num: 14)
        imagePlusLabel.textColor = .darkGray
        explainImage.image = UIImage(named: "ウォーク3")
        explainImage.contentMode = .scaleAspectFit
        explainImage.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        explainImage.layer.borderWidth = 2
        explainImage.layer.cornerRadius = 5
        explainImage.layer.masksToBounds = true
        let explainImage2 = UIImageView()
        explainImage2.image = UIImage(named: "ウォーク4")
        explainImage2.contentMode = .scaleAspectFit
        let imagePlusLabel2 = ProfileLabel(title: "ユーザー設定をしてみてね↓", num: 14)
        imagePlusLabel2.textColor = .darkGray
        explainImage2.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        explainImage2.layer.borderWidth = 2
        explainImage2.layer.cornerRadius = 5
        explainImage2.layer.masksToBounds = true
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        vc.view.addSubview(explainLabel)
        vc.view.addSubview(explainImage)
        vc.view.addSubview(imagePlusLabel)
        vc.view.addSubview(explainImage2)
        vc.view.addSubview(imagePlusLabel2)
        iv.anchor(top: vc.view.topAnchor,
                  paddingTop: 20,
                  centerX: vc.view.centerXAnchor,
                  width: 100,
                  height: 100)
        label.anchor(top: iv.bottomAnchor,
                     paddingTop: 20,
                     centerX: vc.view.centerXAnchor,
                     width: 300,
                     height: 50)
        explainLabel.anchor(top: label.bottomAnchor,
                            paddingTop: 10,
                            centerX: vc.view.centerXAnchor,
                            width: 300,
                            height: 50)
        imagePlusLabel.anchor(top: explainLabel.bottomAnchor,
                              left: vc.view.leftAnchor,
                              right: vc.view.rightAnchor,
                              paddingTop: 20,
                              paddingRight: 20,
                              paddingLeft: 20,
                              height: 20)
        explainImage.anchor(top: imagePlusLabel.bottomAnchor,
                            left: vc.view.leftAnchor,
                            right: vc.view.rightAnchor,
                            paddingTop: 5,
                            paddingRight: 20,
                            paddingLeft: 20,
                            height: 60)
        imagePlusLabel2.anchor(top: explainImage.bottomAnchor,
                               left: vc.view.leftAnchor,
                               right: vc.view.rightAnchor,
                               paddingTop: 20,
                               paddingRight: 20,
                               paddingLeft: 20,
                               height: 20)
        explainImage2.anchor(top: imagePlusLabel2.bottomAnchor,
                             left: vc.view.leftAnchor,
                             right: vc.view.rightAnchor,
                             paddingTop: 5,
                             paddingRight: 20,
                             paddingLeft: 20,
                             height: 60)
        return vc
    }()
    // MARK: - SecondVC
    private let secondVC: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.ImageName.logoImage)
        let label = ProfileLabel(title: "早速初めてみよう！", num: 20)
        label.isHighlighted = false
        label.textColor = .darkGray
        let explainLabel = UITextView()
        explainLabel.text = "ホームでバドミントンをしたい条件や\nキーワードで開催予定の練習を探してみよう"
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
        let explainImage = UIImageView()
        let imagePlusLabel = ProfileLabel(title: "ホームから検索してみよう↓", num: 14)
        imagePlusLabel.textColor = .darkGray
        explainImage.image = UIImage(named: "ウォーク")
        explainImage.contentMode = .scaleAspectFit
        vc.view.addSubview(iv)
        vc.view.addSubview(label)
        vc.view.addSubview(explainLabel)
        vc.view.addSubview(plusLabel)
        vc.view.addSubview(imagePlusLabel)
        vc.view.addSubview(explainImage)
        iv.anchor(top: vc.view.topAnchor,
                  paddingTop: 10,
                  centerX: vc.view.centerXAnchor,
                  width: 100,
                  height: 100)
        explainLabel.anchor(top: iv.bottomAnchor,
                            paddingTop: 5,
                            centerX: vc.view.centerXAnchor,
                            width: 320,
                            height: 50)
        plusLabel.anchor(top: explainLabel.bottomAnchor,
                         paddingTop: 0,
                         centerX: vc.view.centerXAnchor,
                         width: 350,
                         height: 40)
        label.anchor(top: plusLabel.bottomAnchor,
                     paddingTop: 5,
                     centerX: vc.view.centerXAnchor,
                     width: 300,
                     height: 40)
        imagePlusLabel.anchor(top: label.bottomAnchor,
                              left: vc.view.leftAnchor,
                              right: vc.view.rightAnchor,
                              paddingTop: 5,
                              paddingRight: 20,
                              paddingLeft: 20,
                              height: 20)
        explainImage.anchor(top: imagePlusLabel.bottomAnchor,
                            left: vc.view.leftAnchor,
                            right: vc.view.rightAnchor,
                            paddingTop: 5,
                            paddingRight: 20,
                            paddingLeft: 20,
                            height: 230)
        return vc
    }()
    // MARK: - Properties
    private lazy var pages: [UIViewController] = {
        let views = [firstVC, secondVC]
        return views
    }()
    private var pageControl: UIPageControl!
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("はじめてみる", for: .normal)
        button.backgroundColor = .darkGray
        button.isEnabled = false
        button.toCorner(num: 15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        let width = self.view.frame.maxX
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.view.frame.maxY - 100, width: width, height: 50))
        pageControl.backgroundColor = Constants.AppColor.OriginalBlue
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(dismissButton)
        self.view.addSubview(pageControl)
        dismissButton.anchor(bottom: pageControl.topAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor,
                             paddingBottom: 10,
                             paddingRight: 40,
                             paddingLeft: 40,
                             height: 40)
    }
    // MARK: - SelectorMethod
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "MyId")
    }
}
// MARK: - pageViewControllorDatasource
extension WalkThroughController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController), pageIndex - 1 >= 0 {
            pageControl.currentPage = 0
            dismissButton.isEnabled = false
            dismissButton.backgroundColor = .darkGray
            return pages[pageIndex - 1]
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageIndex = pages.firstIndex(of: viewController), pageIndex + 1 < pages.count {
            pageControl.currentPage = 1
            dismissButton.isEnabled = true
            dismissButton.backgroundColor = Constants.AppColor.OriginalBlue
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
