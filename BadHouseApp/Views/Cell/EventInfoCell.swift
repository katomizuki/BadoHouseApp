import UIKit
import SkeletonView
protocol EventInfoCellDelegate: AnyObject {
    func didTapBlockButton(_ cell: EventInfoCell)
}
class EventInfoCell: UICollectionViewCell {
    // Mark Properties
    @IBOutlet weak var teamLabel: UILabel! {
        didSet {
            teamLabel.font = .boldSystemFont(ofSize: 10)
        }
    }
    @IBOutlet weak var blockButton: UIButton! {
        didSet {
            blockButton.layer.cornerRadius = 10
            blockButton.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
            blockButton.layer.masksToBounds = true
            blockButton.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.chageCircle()
            userImageView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
            userImageView.layer.borderWidth = 2
        }
    }
    weak var delegate: EventInfoCellDelegate?
    var event: Event? {
        didSet {
            configure()
        }
    }
    // Mark LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // Mark helperMethod
    func configure() {
        guard let event = event else { return }
        self.placeLabel.text = "at " + event.eventPlace
        var text = event.eventStartTime
        let from = text.index(text.startIndex, offsetBy: 5)
        let to = text.index(text.startIndex, offsetBy: 15)
        text = String(text[from...to])
        let index = text.index(text.startIndex, offsetBy: 5)
        text.insert("日", at: index)
        if text.prefix(1) == "0" {
            let index = text.index(text.startIndex, offsetBy: 0)
            text.remove(at: index)
        }
        text = text.replacingOccurrences(of: "/", with: "月")
        text = text.replacingOccurrences(of: ":", with: "時")
        self.timeLabel.text = text + "分 スタート"
        self.titleLabel.text = event.eventTitle
        self.teamLabel.text = event.teamName
        let urlString = event.eventUrl
        let url = URL(string: urlString)
        let teamurlString = event.teamImageUrl
        if teamurlString != "" {
            let url = URL(string: teamurlString)
            self.userImageView.sd_setImage(with: url, completed: nil)
            self.userImageView.contentMode = .scaleAspectFill
        }
        self.teamImage.sd_setImage(with: url, completed: nil)
    }
    @IBAction func didTapBlockButton(_ sender: Any) {
        self.delegate?.didTapBlockButton(self)
    }
}
