import UIKit

final class LevelDetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var levelLabel: UILabel! {
        didSet {
            levelLabel.text = BadmintonLevel.ten.rawValue
        }
    }
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.tintColor = Constants.AppColor.OriginalBlue
        }
    }
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var textView: UITextView!
    private var selectedLevel = BadmintonLevel.ten.rawValue
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let end = String(selectedLevel.suffix(1))
        setupSlider(level: end)
    }
    // MARK: - IBAction
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - SelectorMethod
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
            textView.text = Constants.Data.levelSentence[8]
        }
        if case 0.9..<1.0 = level {
            levelLabel.text = BadmintonLevel.ten.rawValue
            textView.text = Constants.Data.levelSentence[9]
        }
    }
    // MARK: - SetupMethod
    private func setupSlider(level: String) {
        switch level {
        case "1":
            slider.value = 0.1
            textView.text = Constants.Data.levelSentence[0]
        case "2":
            slider.value = 0.2
            textView.text = Constants.Data.levelSentence[1]
        case "3":
            slider.value = 0.3
            textView.text = Constants.Data.levelSentence[2]
        case "4":
            slider.value = 0.4
            textView.text = Constants.Data.levelSentence[3]
        case "5":
            slider.value = 0.5
            textView.text = Constants.Data.levelSentence[4]
        case "6":
            slider.value = 0.6
            textView.text = Constants.Data.levelSentence[5]
        case "7":
            slider.value = 0.7
            textView.text = Constants.Data.levelSentence[6]
        case "8":
            slider.value = 0.8
            textView.text = Constants.Data.levelSentence[7]
        case "9":
            slider.value = 0.9
            textView.text = Constants.Data.levelSentence[8]
        default:
            slider.value = 1.0
            textView.text = Constants.Data.levelSentence[9]
        }
    }
}
