import UIKit

protocol InputDelegate: AnyObject {
    func inputView(inputView: CustomInputAccessoryView, message: String)
}

final class CustomInputAccessoryView: UIView {
    // MARK: - Properties
    weak var delegate: InputDelegate?
    let messageInputTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 15
        tv.layer.masksToBounds = true
        tv.backgroundColor = .systemBlue
        return tv
    }()
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: R.SFSymbols.paperPlane), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    private let placeholder: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = R.placeholder.input
        return label
    }()
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        addSubview(messageInputTextView)
        addSubview(sendButton)
        addSubview(placeholder)
        sendButton.anchor(leading: messageInputTextView.trailingAnchor,
                          paddingLeft: 5,
                          centerY: messageInputTextView.centerYAnchor,
                          width: 40,
                          height: 40)
        messageInputTextView.anchor(top: topAnchor,
                                    bottom: safeAreaLayoutGuide.bottomAnchor,
                                    leading: leadingAnchor,
                                    trailing: trailingAnchor,
                                    paddingTop: 12,
                                    paddingBottom: 12,
                                    paddingRight: 60,
                                    paddingLeft: 20)
        placeholder.anchor(leading: messageInputTextView.leadingAnchor,
                           paddingLeft: 4,
                           centerY: messageInputTextView.centerYAnchor)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    // MARK: - intrinsticContentSize
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    // MARK: - selector
    @objc private func sendMessage() {
        guard let text = messageInputTextView.text else { return }
        self.delegate?.inputView(inputView: self, message: text)
    }
    
    @objc private func textDidChange() {
        placeholder.isHidden = !self.messageInputTextView.isHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
