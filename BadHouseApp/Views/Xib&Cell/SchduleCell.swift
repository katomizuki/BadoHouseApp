import UIKit
import SDWebImage
import Domain

protocol SchduleCellDelegate: AnyObject {
    func onTapTrashButton(_ cell: SchduleCell)
}

final class SchduleCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.changeCorner(num: 25)
        }
    }
    
    weak var delegate: SchduleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBAction private func didTapTrashButton(_ sender: Any) {
        self.delegate?.onTapTrashButton(self)
    }
    
    func configure(_ practice: Domain.Practice) {
        circleImageView.sd_setImage(with: practice.circleUrl)
        titleLabel.text = practice.title
    }
}
