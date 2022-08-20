import UIKit
import SDWebImage
import Domain

final class InviteCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 20
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var namaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
    }
    
    private func setupCellStyle() {
        selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func configure(_ user: Domain.UserModel) {
        namaLabel.text = user.name
        userImageView.sd_setImage(with: user.profileImageUrl)
    }
}
