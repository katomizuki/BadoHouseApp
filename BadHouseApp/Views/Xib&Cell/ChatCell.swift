import UIKit

final class ChatCell: UITableViewCell {
    // MARK: - Properties
    static let id = String(describing: self)
    var message: String? {
        didSet {
            guard let message = message else { return }
            let width = estimateFrameSize(text: message).width + 20
            messageConstraint.constant = width
            mytextView.text = message
        }
    }
    var yourMessaege: String? {
        didSet {
            guard let message = yourMessaege else { return }
            let width = estimateFrameSize(text: message).width + 20
            widthConstraint.constant = width
            textView.text = message
        }
    }
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet { userImageView.changeCorner(num: 30) }
    }
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!{
        didSet {
            textView.changeCorner(num: 8)
//            textView.autoresizingMask = [.flexibleHeight]
            textView.font = UIFont(name: "Kailasa", size: 14)
        }
    }
    @IBOutlet private weak var mytimeLabel: UILabel!
    @IBOutlet private weak var mytextView: UITextView! {
        didSet {
//            mytextView.autoresizingMask = [.flexibleHeight]
            mytextView.changeCorner(num: 8)
            mytextView.font = UIFont(name: "Kailasa", size: 14)
        }
    }
    @IBOutlet private weak var messageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja-JP")
        return formatter
    }()
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    // MARK: - nibMethod
    static func nib() -> UINib {
        return UINib(nibName:String(describing: self), bundle: nil)
    }
    // MARK: - helperMethod
    private func estimateFrameSize(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                                                   context: nil)
    }
    func configure(chat: GroupChatModel, bool: Bool) {
//        timeLabel.text = ""
//        mytimeLabel.text = ""
//        mytextView.text = ""
//        textView.text = ""
//        message = ""
//        guard let date = chat.timeStamp?.dateValue() else { return }
//        let dateText = self.formatter.string(from: date)
//        let text = chat.text
//        var dateTextFirst = String(dateText.suffix(11))
//        if dateTextFirst.prefix(1) == "/" {
//            dateTextFirst = String(dateTextFirst.suffix(dateTextFirst.count - 1))
//        }
//        if bool {
//            message = text
//            userImageView.isHidden = true
//            timeLabel.isHidden = true
//            textView.isHidden = true
//            nameLabel.isHidden = true
//            mytimeLabel.isHidden = false
//            mytextView.isHidden = false
//            mytimeLabel.text = dateTextFirst
//            mytextView.text = text
//            message = text
//        } else {
//            userImageView.isHidden = false
//            textView.isHidden = false
//            timeLabel.isHidden = false
//            nameLabel.isHidden = false
//            mytextView.isHidden = true
//            mytimeLabel.isHidden = true
//            textView.text = chat.text
//            let urlString = chat.senderUrl
//            let url = URL(string: urlString)
//            nameLabel.text = chat.senderName
//            userImageView.sd_setImage(with: url, completed: nil)
//            timeLabel.text = dateTextFirst
//            yourMessaege = text
//        }
    }
    func dmchatCel(chat: Chat, bool: Bool, you: User) {
//        guard let date = chat.sendTime?.dateValue() else { return }
//        let dateText = self.formatter.string(from: date)
//        var dateTextFirst = String(dateText.suffix(11))
//        if dateTextFirst.prefix(1) == "/" {
//            dateTextFirst = String(dateTextFirst.suffix(dateTextFirst.count - 1))
//        }
//        mytextView.text = ""
//        textView.text = ""
//        timeLabel.text = ""
//        mytimeLabel.text = ""
//        let text = chat.text
//        message = text
//        if bool {
//            userImageView.isHidden = true
//            timeLabel.isHidden = true
//            textView.isHidden = true
//            mytimeLabel.isHidden = false
//            mytextView.isHidden = false
//            nameLabel.isHidden = true
//            mytimeLabel.text = dateTextFirst
//            mytextView.text = text
//            message = text
//        } else {
//            userImageView.isHidden = false
//            let urlString = you.profileImageUrl
//            let url = URL(string: urlString)
//            userImageView.sd_setImage(with: url, completed: nil)
//            mytextView.isHidden = true
//            mytimeLabel.isHidden = true
//            textView.isHidden = false
//            timeLabel.isHidden = false
//            nameLabel.isHidden = false
//            nameLabel.text =  you.name
//            timeLabel.text = dateTextFirst
//            textView.text = text
//            yourMessaege = text
//        }
    }
}
