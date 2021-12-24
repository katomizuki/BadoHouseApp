//
//  InviteCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit

class InviteCell: UITableViewCell {
    static let id = String(describing: self)
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 20
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var namaLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib()->UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
