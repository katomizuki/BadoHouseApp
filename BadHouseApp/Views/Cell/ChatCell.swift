import UIKit

class ChatCell: UITableViewCell {
    
    //Mark:properties
    var message: String? {
        didSet {
            guard let message = message else { return }
            let width = estimateFrameSize(text: message).width + 20
            messageConstraint.constant = width
            mytextView.text = message
            print("🍎")
            print(width)
            print(message)
        }
    }
    var yourMessaege:String? {
        didSet {
            guard let message = yourMessaege else { return }
            let width = estimateFrameSize(text: message).width + 20
            widthConstraint.constant = width
            textView.text = message
            
        }
    }
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mytimeLabel: UILabel!
    @IBOutlet weak var mytextView: UITextView!
    @IBOutlet weak var messageConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    //Mark: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
        userImageView.layer.masksToBounds = true
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        mytextView.layer.cornerRadius = 15
        mytextView.layer.masksToBounds = true
        backgroundColor = .clear
        textView.autoresizingMask = [.flexibleHeight]
        mytextView.autoresizingMask = [.flexibleHeight]


    }
    
    //Mark: nibMethod
    static func nib()->UINib {
        return UINib(nibName: "ChatCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimateFrameSize(text:String)->CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
}

