//
//  NotificationCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import UIKit

final class NotificationCell: UITableViewCell {
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib()-> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
