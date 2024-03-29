import UIKit
import SDWebImage
import Domain

final class NotificationCell: UICollectionViewCell {

    static let id = String(describing: self)

    @IBOutlet private weak var notificationImageView: UIImageView! {
        didSet {
            notificationImageView.layer.cornerRadius = 20
            notificationImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(_ notification: Domain.Notification) {
        notificationImageView.sd_setImage(with: notification.url)
        switch notification.notificationSelection {
        case .applyed:
            titleLabel.text = "\(notification.titleText)さんから友だち申請がきました"
        case .prejoined:
            titleLabel.text = "\(notification.titleText)さんから参加申請がきました"
        case .permissionJoin:
            titleLabel.text = "\(notification.titleText)さんから参加承認がおりました"
        case .permissionFriend:
            titleLabel.text = "\(notification.titleText)さんと友だちになりました"
        }
    }
}
