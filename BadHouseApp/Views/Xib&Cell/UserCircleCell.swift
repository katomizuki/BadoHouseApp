//
//  UserCircleCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/23.
//

import UIKit

final class UserCircleCell: UICollectionViewCell {
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.layer.cornerRadius = 25
            circleImageView.layer.masksToBounds = true
        }
    }
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib()-> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

}
