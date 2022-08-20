import UIKit
import Domain

final class UserCircleCell: UICollectionViewCell {
    
    static let id = String(describing: self)

    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.layer.cornerRadius = 25
            circleImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var permissionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(_ circle: Domain.CircleModel) {
        circleImageView.sd_setImage(with: circle.iconUrl)
        nameLabel.text = circle.name
    }
}
