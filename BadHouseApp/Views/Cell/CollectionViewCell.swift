import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    //Mark:Properties
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    //Mark:LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.chageCircle()
    }
}
