import UIKit
import Domain

protocol EventInfoCellDelegate: AnyObject {
    func didTapBlockButton(_ cell: EventInfoCell,
                           practice: Domain.Practice)
}

final class EventInfoCell: UICollectionViewCell {
    
    static let id = String(describing: self)
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
    private var practice: Domain.Practice?
    weak var delegate: EventInfoCellDelegate?
    
    // MARK: - LifeCycle
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ practice: Domain.Practice) {
        self.practice = practice
        teamLabel.text = practice.circleName
        teamImage.sd_setImage(with: practice.mainUrl)
        userImageView.sd_setImage(with: practice.circleUrl)
        titleLabel.text = practice.title
        placeLabel.text = "場所  \(practice.placeName)"
        timeLabel.text = "時間  \(practice.startTimeSring)"
    }
    
    @IBAction private func didTapAlertButton(_ sender: Any) {
        guard let practice = practice else { return }
        self.delegate?.didTapBlockButton(self, practice: practice)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamLabel.text = nil
        titleLabel.text = nil
        placeLabel.text = nil
        timeLabel.text = nil
    }
}
