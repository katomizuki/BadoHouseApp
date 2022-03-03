import UIKit
import SDWebImage

protocol ApplyedUserListCellDelegate: AnyObject {
    func onTapPermissionButton(_ applyed: Applyed)
}

final class ApplyedUserListCell: UITableViewCell {

    static let id = String(describing: self)

    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.changeCorner(num: 25)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    
    weak var delegate: ApplyedUserListCellDelegate?
    var applyed: Applyed?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBAction private func didTapPermissionButton(_ sender: Any) {
        if let applyed = applyed {
            self.delegate?.onTapPermissionButton(applyed)
        }
    }
    
    func configure(_ applyed: Applyed) {
        self.applyed = applyed
        nameLabel.text = applyed.name
        userImageView.sd_setImage(with: applyed.url)
    }
}
