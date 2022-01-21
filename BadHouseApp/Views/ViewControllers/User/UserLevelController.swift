import UIKit

protocol UserLevelDelegate: AnyObject {
    func UserLevelController(vc: UserLevelController,
                             text: String)
}

final class UserLevelController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private weak var textView: UITextView! 
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(changeLevel(sender:)), for: .valueChanged)
        }
    }
    @IBOutlet private weak var levelLabel: UILabel! 
    var user: User
    weak var delegate: UserLevelDelegate?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider(level: user.level)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapDismissButton))
   }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    // MARK: SelectorMethod
    @objc private func didTapDismissButton() {
        self.delegate?.UserLevelController(vc: self, text: levelLabel.text ?? "レベル1")
    }
    
    @objc private func changeLevel(sender: UISlider) {
        let level = Double(sender.value)
        levelLabel.text = sender.getLevelText(level)
        textView.text = sender.getLevelSentence(level)
    }
    // MARK: - setupMethod
    private func setupSlider(level: String) {
        levelLabel.text = level
        let value = Float(Int(level.suffix(1))!) / 10
        slider.value = value
        textView.text = slider.getLevelSentence(Double(value))
    }
}
