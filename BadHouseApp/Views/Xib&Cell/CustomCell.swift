import Foundation
import UIKit
import SDWebImage
import Domain

protocol CalendarEventDelegate: AnyObject {
    func removeEvent(eventModel: Domain.Practice, cell: UITableViewCell)
}

final class CustomCell: UITableViewCell {
    // MARK: - Properties
    static let id = String(describing: self)
    
    @IBOutlet private weak var cellImagevView: UIImageView! {
        didSet {
            self.cellImagevView.layer.cornerRadius = 25
            self.cellImagevView.layer.masksToBounds = true
            self.cellImagevView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var label: UILabel! {
        didSet {
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    @IBOutlet private weak var commentLabel: UILabel! {
        didSet {
            commentLabel.font = .boldSystemFont(ofSize: 12)
        }
    }
    @IBOutlet private weak var timeLabel: UILabel!
   
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    private let trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: R.SFSymbols.trash), for: UIControl.State.normal)
        return button
    }()
    
    weak var trashDelegate: CalendarEventDelegate?
    // MARK: - LifeCycle
    override  func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        setupCellStyle()
        setupTrashButton()
    }
    
    private func setupTrashButton() {
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
    
    private func setupCellStyle() {
        accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
    // MARK: - nibMethod
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    // MARK: - selector
    @objc private func handleTrash() {
    }
    
    func configure(user: Domain.UserModel) {
        cellImagevView.sd_setImage(with: user.profileImageUrl)
        label.text = user.name
    }
    
    func configure(circle: Domain.CircleModel) {
        cellImagevView.sd_setImage(with: circle.iconUrl)
        label.text = circle.name
    }
    
    func configure(practice: Practice) {
        cellImagevView.sd_setImage(with: practice.circleUrl)
        label.text = practice.title
    }
    
    func configure(chatRoom: ChatRoom) {
        cellImagevView.sd_setImage(with: chatRoom.partnerUrl)
        label.text = chatRoom.partnerName
        commentLabel.text = chatRoom.latestMessage
        commentLabel.isHidden = false
        timeLabel.isHidden = false
        timeLabel.text = chatRoom.latestTimeString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        commentLabel.text = nil
        timeLabel.text = nil
    }
}
