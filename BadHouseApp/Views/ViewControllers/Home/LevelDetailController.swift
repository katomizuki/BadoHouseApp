import UIKit
//protocol LevelDetailFlow {
//    func dismiss()
//}
final class LevelDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton! 
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var textView: UITextView!
//    var coordinator:LevelDetailFlow?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = Constants.Data.levelSentence[5]
    }
    // MARK: - IBAction
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true)
    }
    // MARK: - SelectorMethod
    @objc private func changeLevel(sender: UISlider) {
        let level = Double(sender.value)
        if case 0..<0.1 = level {
            levelLabel.text = BadmintonLevel(rawValue: 0)?.description
            textView.text = Constants.Data.levelSentence[0]
        }
        if case 0.1..<0.2 = level {
            levelLabel.text = BadmintonLevel(rawValue: 1)?.description
            textView.text = Constants.Data.levelSentence[1]
        }
        if case 0.2..<0.3 = level {
            levelLabel.text = BadmintonLevel(rawValue: 2)?.description
            textView.text = Constants.Data.levelSentence[2]
        }
        if case 0.3..<0.4 = level {
            levelLabel.text = BadmintonLevel(rawValue: 3)?.description
            textView.text = Constants.Data.levelSentence[3]
        }
        if case 0.4..<0.5 = level {
            levelLabel.text = BadmintonLevel(rawValue: 4)?.description
            textView.text = Constants.Data.levelSentence[4]
        }
        if case 0.5..<0.6 = level {
            levelLabel.text = BadmintonLevel(rawValue: 5)?.description
            textView.text = Constants.Data.levelSentence[5]
        }
        if case 0.6..<0.7 = level {
            levelLabel.text = BadmintonLevel(rawValue: 6)?.description
            textView.text = Constants.Data.levelSentence[6]
        }
        if case 0.7..<0.8 = level {
            levelLabel.text = BadmintonLevel(rawValue: 7)?.description
            textView.text = Constants.Data.levelSentence[7]
        }
        if case 0.8..<0.9 = level {
            levelLabel.text = BadmintonLevel(rawValue: 8)?.description
            textView.text = Constants.Data.levelSentence[8]
        }
        if case 0.9..<1.0 = level {
            levelLabel.text = BadmintonLevel(rawValue: 9)?.description
            textView.text = Constants.Data.levelSentence[9]
        }
    }
}
