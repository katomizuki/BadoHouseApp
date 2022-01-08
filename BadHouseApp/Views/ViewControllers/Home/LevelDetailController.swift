import UIKit

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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = R.array.levelSentence[5]
    }
    // MARK: - IBAction
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true)
    }
    // MARK: - SelectorMethod
    @objc private func changeLevel(sender: UISlider) {
        let level = Double(sender.value)
        levelLabel.text = sender.getLevelSentence(level)
        textView.text = sender.getLevelText(level)
    }
}
