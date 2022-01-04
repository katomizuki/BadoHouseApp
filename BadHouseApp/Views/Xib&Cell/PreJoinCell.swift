//
//  PreJoinCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import UIKit

final class PreJoinCell: UITableViewCell {
    
    @IBOutlet private weak var label: UILabel!
    static let id = String(describing: self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static func nib()->UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
