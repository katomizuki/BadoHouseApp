//
//  SchduleCell.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/24.
//

import UIKit
protocol SchduleCellDelegate:AnyObject {
    func onTapTrashButton(_ cell:SchduleCell)
}
final class SchduleCell: UITableViewCell {

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
    static func nib() ->UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBAction func didTapTrashButton(_ sender: Any) {
        self.delegate?.onTapTrashButton(self)
    }
}
