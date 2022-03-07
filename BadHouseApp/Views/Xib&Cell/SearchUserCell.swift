import UIKit
import SDWebImage

protocol SearchUserCellDelegate: AnyObject {
    func searchUserCellApply(_ user: User, cell: SearchUserCell)
    func searchUserCellNotApply(_ user: User, cell: SearchUserCell)

}

final class SearchUserCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 20
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var applyFriendButton: UIButton! {
        didSet {
            applyFriendButton.layer.cornerRadius = 8
            applyFriendButton.layer.masksToBounds = true
            applyFriendButton.layer.borderColor = UIColor.systemBlue.cgColor
            applyFriendButton.layer.borderWidth = 1
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    
    var user: User?
    weak var delegate: SearchUserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBAction private func didTapApplyFriendsButton(_ sender: Any) {
        guard let user = user else { return }
        if judgeButtonAction(applyFriendButton.currentTitle) {
            self.delegate?.searchUserCellNotApply(user, cell: self)
        } else {
            self.delegate?.searchUserCellApply(user, cell: self)
        }
        applyFriendButton.setTitle(changeButtonTitle(applyFriendButton.currentTitle), for: .normal)
    }
    
    func configure(_ user: User) {
        self.user = user
        userImageView.sd_setImage(with: user.profileImageUrl)
        nameLabel.text = user.name
    }
    
    private func changeButtonTitle(_ text: String?) -> String {
        return text == R.buttonTitle.alreadyApply ? R.buttonTitle.apply : R.buttonTitle.alreadyApply
    }
    
    private func judgeButtonAction(_ text: String?) -> Bool {
        return text == R.buttonTitle.alreadyApply
    }
    
}
