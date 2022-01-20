//
//  SchduleCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
import SDWebImage
protocol SchduleCellDelegate:AnyObject {
    func onTapTrashButton(_ cell:SchduleCell)
}
final class SchduleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var circleImageView: UIImageView! {
        didSet {
            circleImageView.changeCorner(num: 25)
        }
    }
    static let id = String(describing: self)
    weak var delegate: SchduleCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBAction func didTapTrashButton(_ sender: Any) {
        self.delegate?.onTapTrashButton(self)
    }
    func configure(_ practice: Practice) {
        circleImageView.sd_setImage(with: practice.circleUrl)
        titleLabel.text = practice.title
    }
}
