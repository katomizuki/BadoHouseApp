//
//  NotificationCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import UIKit

final class NotificationCell: UICollectionViewCell {
    @IBOutlet weak var notificationImageView: UIImageView! {
        didSet {
            notificationImageView.layer.cornerRadius = 20
            notificationImageView.layer.masksToBounds = true
        }
    }
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

}
