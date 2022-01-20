import UIKit
import SDWebImage

protocol PreJoinCellDelegate: AnyObject {
    func preJoinCell(_ cell: PreJoinCell,preJoin: PreJoin)
}
final class PreJoinCell: UITableViewCell {
    weak var delegate:PreJoinCellDelegate?
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.layer.cornerRadius = 25
            circleImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var label: UILabel!
    static let id = String(describing: self)
    var preJoin:PreJoin?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(_ prejoin: PreJoin) {
        self.preJoin = prejoin
        circleImageView.sd_setImage(with: prejoin.url)
        label.text = "「\(prejoin.practiceName)」に参加申請中です"
    }
    
    @IBAction func didTapTrashButton(_ sender: Any) {
        guard let preJoin = preJoin else {
            return
        }
        self.delegate?.preJoinCell(self, preJoin: preJoin)
    }
}
