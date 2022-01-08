//
//  NotificationCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import UIKit
import SDWebImage
final class NotificationCell: UICollectionViewCell {
    @IBOutlet private weak var notificationImageView: UIImageView! {
        didSet {
            notificationImageView.layer.cornerRadius = 20
            notificationImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    func configure(_ notification: Notification) {
        notificationImageView.sd_setImage(with: notification.url)
        switch notification.notificationSelection {
        case .applyed:
            titleLabel.text = "\(notification.titleText)さんから友だち申請がきました"
        case .prejoined:
            titleLabel.text = "\(notification.titleText)さんから参加申請がきました"
        case .permissionJoin:
            titleLabel.text = "\(notification.titleText)さんから参加承認がおりました"
        case .permissionFriend:
            titleLabel.text = "\(notification.titleText)さんから友だち承認がおりました"
        }
    }

}
