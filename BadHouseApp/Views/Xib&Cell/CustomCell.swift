import Foundation
import UIKit
import SDWebImage

protocol CalendarEventDelegate: AnyObject {
    func removeEvent(eventModel: Practice, cell: UITableViewCell)
}
final class CustomCell: UITableViewCell {
    // MARK: - Properties
    static let id = String(describing: self)
    @IBOutlet weak var cellImagevView: UIImageView! {
        didSet {
            self.cellImagevView.layer.cornerRadius = 25
            self.cellImagevView.layer.masksToBounds = true
            self.cellImagevView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    @IBOutlet weak var commentLabel: UILabel! {
        didSet {
            commentLabel.font = .boldSystemFont(ofSize: 12)
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    weak var trashDelegate: CalendarEventDelegate?
   
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: UIControl.State.normal)
        return button
    }()
    // MARK: - LifeCycle
    override  func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        addSubview(trashButton)
        trashButton.isHidden = true
        trashButton.anchor(bottom: bottomAnchor,
                           trailing: trailingAnchor,
                           paddingBottom: 10,
                           paddingRight: 20,
                           width: 30,
                           height: 30)
        trashButton.addTarget(self, action: #selector(handleTrash), for: .touchUpInside)
    }
    // MARK: - nibMethod
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    // MARK: - selector
    @objc private func handleTrash() {
    }
    
    func configure(user: User) {
        cellImagevView.sd_setImage(with: user.profileImageUrl)
        label.text = user.name
    }
    func configure(circle: Circle) {
        cellImagevView.sd_setImage(with: circle.iconUrl)
        label.text = circle.name
    }
    func configure(practice: Practice) {
        cellImagevView.sd_setImage(with: practice.circleUrl)
        label.text = practice.title
    }
  
    func setTimeLabelandCommentLabel(chat: Chat) {
        let text = chat.text
        let date = chat.sendTime
        self.commentLabel.text = text
        if  date != nil {
            if let safeTimeStamp = date {
                let safeDate = safeTimeStamp.dateValue()
                let dateText = self.formatter.string(from: safeDate)
                self.timeLabel.text = dateText
                self.timeLabel.isHidden = false
            }
        }
    }
}
