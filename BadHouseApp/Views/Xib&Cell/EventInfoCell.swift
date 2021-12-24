import UIKit

protocol EventInfoCellDelegate: AnyObject {
    func didTapBlockButton(_ cell: EventInfoCell)
}
final class EventInfoCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var teamLabel: UILabel! {
        didSet {
            teamLabel.font = .boldSystemFont(ofSize: 10)
        }
    }
    @IBOutlet private weak var mainView: UIView! {
        didSet {
            mainView.layer.cornerRadius = 8
            mainView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var teamImage: UIImageView! {
        didSet {
            teamImage.layer.cornerRadius = 8
            teamImage.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 25
            userImageView.layer.masksToBounds = true
        }
    }
    weak var delegate: EventInfoCellDelegate?
    var event: Event? {
        didSet {
            configure()
        }
    }
    // MARK: - LifeCycle
    static let id = String(describing: self)
    
    static func nib()-> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    // MARK: - helperMethod
    func configure() {
    }
}
