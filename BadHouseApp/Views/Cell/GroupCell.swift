

import Foundation
import UIKit

class GroupCell:UITableViewCell {
 
    @IBOutlet weak var cellImagevView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() ->UINib {
        return UINib(nibName: Utility.Cell.GroupCell, bundle: nil)
    }
    
}
