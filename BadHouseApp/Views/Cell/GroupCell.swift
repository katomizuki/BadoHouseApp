import Foundation
import UIKit

class GroupCell:UITableViewCell {
 
    //Mark:Properties
    @IBOutlet weak var cellImagevView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //Mark: LifeCycle
    override  func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Mark: nibMethod
    static func nib() ->UINib {
        return UINib(nibName: Utility.Cell.GroupCell, bundle: nil)
    }
    
}
