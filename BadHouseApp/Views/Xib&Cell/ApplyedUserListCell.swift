import UIKit
import SDWebImage
import Domain

protocol ApplyedUserListCellDelegate: AnyObject {
    func onTapPermissionButton(_ applyed: Domain.ApplyedModel)
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
    private var applyed: Domain.ApplyedModel?
    
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
    
    func configure(_ applyed: Domain.ApplyedModel) {
        self.applyed = applyed
        nameLabel.text = applyed.name
        userImageView.sd_setImage(with: applyed.url)
    }
}
