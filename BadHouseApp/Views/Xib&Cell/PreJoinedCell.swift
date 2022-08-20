import UIKit
import SDWebImage
import Domain
protocol PreJoinedCellDelegate: AnyObject {
    func preJoinedCell(prejoined: Domain.PreJoined)
}

final class PreJoinedCell: UITableViewCell {
    
    static let id = String(describing: self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 25
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var label: UILabel!
    
    private var preJoined: Domain.PreJoined?
    weak var delegate: PreJoinedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ prejoined: Domain.PreJoined) {
        self.preJoined = prejoined
        userImageView.sd_setImage(with: prejoined.url)
        label.text = "\(prejoined.name) さん から参加申請がきております"
        titleLabel.text = "「\(prejoined.practiceName)」"
    }
    
    @IBAction private func didTapPermissionButton(_ sender: Any) {
        guard let preJoined = preJoined else { return }
        self.delegate?.preJoinedCell(prejoined: preJoined)
    }
}
