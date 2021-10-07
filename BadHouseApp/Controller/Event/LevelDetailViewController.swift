import UIKit

class LevelDetailViewController: UIViewController {
    
    //Mark properties
    @IBOutlet private weak var levelLabel: UILabel! {
        didSet {
            levelLabel.text = "レベル10"
        }
    }
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.updateBackbutton()
        }
    }
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var textView: UITextView!
    private var selectedLevel = "レベル10"
    
    //Mark:lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let end = String(selectedLevel.suffix(1))
        setupSlider(level:end)
    }
    //Mark IBAction
    @IBAction private func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //Mark selector
    @objc private func changeLevel(sender:UISlider) {
        let level = Double(sender.value)
        //分割して条件分岐する
        if case 0..<0.1 = level {
            levelLabel.text = "レベル1"
            textView.text = Utility.Data.levelSentence[0]
        }
        if case 0.1..<0.2 = level {
            levelLabel.text = "レベル2"
            textView.text = Utility.Data.levelSentence[1]
        }
        if case 0.2..<0.3 = level {
            levelLabel.text = "レベル3"
            textView.text = Utility.Data.levelSentence[2]
        }
        if case 0.3..<0.4 = level {
            levelLabel.text = "レベル4"
            textView.text = Utility.Data.levelSentence[3]
        }
        if case 0.4..<0.5 = level {
            levelLabel.text = "レベル5"
            textView.text = Utility.Data.levelSentence[4]
        }
        if case 0.5..<0.6 = level {
            levelLabel.text = "レベル6"
            textView.text = Utility.Data.levelSentence[5]
        }
        if case 0.6..<0.7 = level {
            levelLabel.text = "レベル7"
            textView.text = Utility.Data.levelSentence[6]
        }
        if case 0.7..<0.8 = level {
            levelLabel.text = "レベル8"
            textView.text = Utility.Data.levelSentence[7]
        }
        if case 0.8..<0.9 = level {
            levelLabel.text = "レベル9"
            textView.text = Utility.Data.levelSentence[8]
        }
        if case 0.9..<1.0 = level {
            levelLabel.text = "レベル10"
            textView.text = Utility.Data.levelSentence[9]
        }
    }
    
    //Mark:setupMethod
    private func setupSlider(level:String) {
        switch level {
        case "1":
            slider.value = 0.1
            textView.text = Utility.Data.levelSentence[0]
        case "2":
            slider.value = 0.2
            textView.text = Utility.Data.levelSentence[1]
        case "3":
            slider.value = 0.3
            textView.text = Utility.Data.levelSentence[2]
            
        case "4":
            slider.value = 0.4
            textView.text = Utility.Data.levelSentence[3]
        case "5":
            slider.value = 0.5
            textView.text = Utility.Data.levelSentence[4]
        case "6":
            slider.value = 0.6
            textView.text = Utility.Data.levelSentence[5]
        case "7":
            slider.value = 0.7
            textView.text = Utility.Data.levelSentence[6]
        case "8":
            slider.value = 0.8
            textView.text = Utility.Data.levelSentence[7]
        case "9":
            slider.value = 0.9
            textView.text = Utility.Data.levelSentence[8]
        default:
            slider.value = 1.0
            textView.text = Utility.Data.levelSentence[9]
        }
    }
}
