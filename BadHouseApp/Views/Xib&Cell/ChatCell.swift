import UIKit
import SDWebImage
final class ChatCell: UITableViewCell {
    // MARK: - Properties
    static let id: String = String(describing: self)

    @IBOutlet private weak var userImageView: UIImageView! {
        didSet { userImageView.changeCorner(num: 30) }
    }
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var textView: UITextView! {
        didSet {
            textView.changeCorner(num: 8)
            textView.font = UIFont(name: "Kailasa", size: 14)
        }
    }
    @IBOutlet private weak var mytimeLabel: UILabel!
    @IBOutlet private weak var mytextView: UITextView! {
        didSet {
            mytextView.changeCorner(num: 8)
            mytextView.font = UIFont(name: "Kailasa", size: 14)
        }
    }
    @IBOutlet private weak var messageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!

    private let formatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja-JP")
        return formatter
    }()
    
    var message: String? {
        didSet {
            guard let message: String = message else { return }
            let width: CGFloat = CGFloat(estimateFrameSize(text: message).width) + CGFloat(15)
            messageConstraint.constant = width
            mytextView.text = message
        }
    }
    var yourMessaege: String? {
        didSet {
            guard let message: String = yourMessaege else { return }
            let width = estimateFrameSize(text: message).width + 15
            widthConstraint.constant = width
            textView.text = message
        }
    }
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        setupCellStyle()
    }
    
    private func setupCellStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        isHighlighted = false
    }
    // MARK: - nibMethod
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    // MARK: - helperMethod
    private func estimateFrameSize(text: String) -> CGRect {
        let size: CGSize = CGSize(width: 200, height: 1000)
        let options: NSStringDrawingOptions = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                                   context: nil)
    }

    func configure(chat: Chat, user: User, myData: User) {
        if chat.senderId == myData.uid {
            timeLabel.isHidden = true
            textView.isHidden = true
            nameLabel.isHidden = true
            userImageView.isHidden = true
            mytimeLabel.isHidden = false
            mytextView.isHidden = false
            message = chat.text
            mytimeLabel.text = chat.timeString
        } else {
            timeLabel.isHidden = false
            textView.isHidden = false
            nameLabel.isHidden = false
            userImageView.isHidden = false
            mytimeLabel.isHidden = true
            mytextView.isHidden = true
            nameLabel.text = user.name
            userImageView.sd_setImage(with: user.profileImageUrl)
            yourMessaege = chat.text
            timeLabel.text = chat.timeString
        }
    }
    
    override func prepareForReuse() {
        timeLabel.text = nil
        nameLabel.text = nil
        mytimeLabel.text = nil
        textView.text = nil
    }
}
