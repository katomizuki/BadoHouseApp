import UIKit
import SDWebImage

protocol ApplyUserListCellDelegate:AnyObject {
    func onTapTrashButton(_ apply:Apply, cell:ApplyUserListCell)
}
final class ApplyUserListCell: UITableViewCell {
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.changeCorner(num: 25)
        }
    }
    @IBOutlet private weak var nameLabel: UILabel!
    private var apply: Apply?
    weak var delegate: ApplyUserListCellDelegate?
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    func configure(_ apply: Apply) {
        self.apply = apply
        userImageView.sd_setImage(with: apply.url)
        nameLabel.text = apply.name
    }

    @IBAction func didTapTrashButton(_ sender: Any) {
        if let apply = apply {
            self.delegate?.onTapTrashButton(apply, cell: self)
        }
    }
    
}
