import UIKit
import Foundation

final class BlockTextView: UITextView {
    // Mark properties
    var placeholder: UILabel = {
        let label = UILabel()
        label.text = "通報する理由を\nご記入してください。\n運営で適切に\n対処させていただきます。"
        label.numberOfLines = 4
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    // Mark initialize
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        addSubview(placeholder)
        placeholder.anchor(top: topAnchor,
                           left: leftAnchor,
                           paddingTop: 10,
                           paddingLeft: 10)
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleChangePlaceholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 15
        layer.masksToBounds = true
        backgroundColor = UIColor(named: "TFColor")
    }
    @objc private func handleChangePlaceholder() {
        placeholder.isHidden = !text.isEmpty
    }
}
