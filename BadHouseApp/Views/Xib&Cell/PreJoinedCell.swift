//
//  PreJoinedCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2022/01/04.
//

import UIKit
import SDWebImage
protocol PreJoinedCellDelegate:AnyObject {
    func preJoinedCell(prejoined: PreJoined)
}
final class PreJoinedCell: UITableViewCell {
    static let id = String(describing: self)
    weak var delegate:PreJoinedCellDelegate?
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure() {
       
    }
    
    @IBAction func didTapPermissionButton(_ sender: Any) {
//        self.delegate?.preJoinedCell(prejoined: pre)
    }
}
