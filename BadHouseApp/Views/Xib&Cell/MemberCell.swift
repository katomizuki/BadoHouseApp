//
//  MemberCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/23.
//

import UIKit

final class MemberCell: UITableViewCell {
    @IBOutlet private weak var memberImageView: UIImageView! {
        didSet {
            memberImageView.layer.masksToBounds = true
            memberImageView.layer.cornerRadius = 15
        }
    }
    static let id = String(describing: self)
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    static func nib()->UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

  
}
