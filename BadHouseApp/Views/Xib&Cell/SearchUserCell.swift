//
//  SearchUserCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit

final class SearchUserCell: UITableViewCell {
    static let id = String(describing: self)
    @IBOutlet private weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = 20
            userImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var applyFriendButton: UIButton! {
        didSet {
            applyFriendButton.layer.cornerRadius = 8
            applyFriendButton.layer.masksToBounds = true
            applyFriendButton.layer.borderColor = UIColor.systemBlue.cgColor
            applyFriendButton.layer.borderWidth = 1
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }
    static func nib()->UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBAction private func didTapApplyFriendsButton(_ sender: Any) {
    }
    
}
