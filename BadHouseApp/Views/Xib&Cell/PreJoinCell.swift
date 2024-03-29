import UIKit
import SDWebImage
import Domain

protocol PreJoinCellDelegate: AnyObject {
    func preJoinCell(_ cell: PreJoinCell,
                     preJoin: Domain.PreJoin)
}

final class PreJoinCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.layer.cornerRadius = 25
            circleImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var label: UILabel!
   
    private var preJoin: Domain.PreJoin?
    weak var delegate: PreJoinCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ prejoin: Domain.PreJoin) {
        self.preJoin = prejoin
        circleImageView.sd_setImage(with: prejoin.url)
        label.text = "「\(prejoin.practiceName)」に参加申請中です"
    }
    
    @IBAction private func didTapTrashButton(_ sender: Any) {
        guard let preJoin = preJoin else { return }
        self.delegate?.preJoinCell(self, preJoin: preJoin)
    }
}
