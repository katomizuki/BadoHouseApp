import UIKit
protocol LevelDismissDelegate: AnyObject {
    func levelDismiss(vc: UserLevelController)
}
final class UserLevelController: UIViewController {
    // MARK: - Properties
    weak var delegate: LevelDismissDelegate?
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
            backButton.tintColor = Constants.AppColor.OriginalBlue
            backButton.addTarget(self, action: #selector(backtoUser), for: .touchUpInside)
        }
    }
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        }
    }
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var levelLabel: UILabel! {
        didSet {
            levelLabel.text = BadmintonLevel.ten.rawValue
        }
    }
    var selectedLevel = String()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let end = String(selectedLevel.suffix(1))
        setupSlider(level: end)
    }
    // MARK: SelectorMethod
    @objc private func backtoUser() {
        selectedLevel = levelLabel.text ?? "1"
        let vc = self.presentingViewController as! UserPageController
//        vc.level = selectedLevel
        self.delegate?.levelDismiss(vc: self)
    }
    @objc private func changeLevel(sender: UISlider) {
        let level = Double(sender.value)
        if case 0..<0.1 = level {
            levelLabel.text = BadmintonLevel.one.rawValue
            textView.text = Constants.Data.levelSentence[0]
        }
        if case 0.1..<0.2 = level {
            levelLabel.text = BadmintonLevel.two.rawValue
            textView.text = Constants.Data.levelSentence[1]
        }
        if case 0.2..<0.3 = level {
            levelLabel.text = BadmintonLevel.three.rawValue
            textView.text = Constants.Data.levelSentence[2]
        }
        if case 0.3..<0.4 = level {
            levelLabel.text = BadmintonLevel.four.rawValue
            textView.text = Constants.Data.levelSentence[3]
        }
        if case 0.4..<0.5 = level {
            levelLabel.text = BadmintonLevel.five.rawValue
            textView.text = Constants.Data.levelSentence[4]
        }
        if case 0.5..<0.6 = level {
            levelLabel.text = BadmintonLevel.six.rawValue
            textView.text = Constants.Data.levelSentence[5]
        }
        if case 0.6..<0.7 = level {
            levelLabel.text = BadmintonLevel.seven.rawValue
            textView.text = Constants.Data.levelSentence[6]
        }
        if case 0.7..<0.8 = level {
            levelLabel.text = BadmintonLevel.eight.rawValue
            textView.text = Constants.Data.levelSentence[7]
        }
        if case 0.8..<0.9 = level {
            levelLabel.text = BadmintonLevel.nine.rawValue
            textView.text =  Constants.Data.levelSentence[8]
        }
        if case 0.9..<1.0 = level {
            levelLabel.text = BadmintonLevel.ten.rawValue
            textView.text = Constants.Data.levelSentence[9]
        }
    }
    // MARK: - setupMethod
    private func setupSlider(level: String) {
        switch level {
        case "1":
            slider.value = 0.1
            textView.text = Constants.Data.levelSentence[0]
            levelLabel.text = "レベル1"
        case "2":
            slider.value = 0.2
            textView.text = Constants.Data.levelSentence[1]
            levelLabel.text = "レベル2"
        case "3":
            slider.value = 0.3
            textView.text = Constants.Data.levelSentence[2]
            levelLabel.text = "レベル3"
        case "4":
            slider.value = 0.4
            textView.text = Constants.Data.levelSentence[3]
            levelLabel.text = "レベル4"
        case "5":
            slider.value = 0.5
            textView.text = Constants.Data.levelSentence[4]
            levelLabel.text = "レベル5"
        case "6":
            slider.value = 0.6
            textView.text = Constants.Data.levelSentence[5]
            levelLabel.text = "レベル6"
        case "7":
            slider.value = 0.7
            textView.text = Constants.Data.levelSentence[6]
            levelLabel.text = "レベル7"
        case "8":
            slider.value = 0.8
            textView.text = Constants.Data.levelSentence[7]
            levelLabel.text = "レベル8"
        case "9":
            slider.value = 0.9
            textView.text = Constants.Data.levelSentence[8]
            levelLabel.text = "レベル9"
        default:
            slider.value = 1.0
            textView.text = Constants.Data.levelSentence[9]
            levelLabel.text = "レベル10"
        }
    }
}
