import UIKit
import SDWebImage

final class MemberCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var memberImageView: UIImageView! {
        didSet {
            memberImageView.layer.masksToBounds = true
            memberImageView.layer.cornerRadius = 15
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(_ user: User) {
        memberImageView.sd_setImage(with: user.profileImageUrl)
        nameLabel.text = user.name
    }
}
