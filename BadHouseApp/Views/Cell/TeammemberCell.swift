import Foundation
import UIKit
import SDWebImage

class TeammemberCell:UICollectionViewCell {
    
    //Mark:Properties
    var teamMember = [User]()
    @IBOutlet weak var teamMemberImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //Mark:nibMethod
    static func nib()->UINib {
        return UINib(nibName:Utility.Cell.TeammemberCell, bundle: nil)
    }
    
    //Mark:LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        teamMemberImage.layer.cornerRadius = 30
        teamMemberImage.layer.masksToBounds = true
        teamMemberImage.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        teamMemberImage.layer.borderWidth = 2
        teamMemberImage.contentMode = .scaleAspectFill
    }
    
    //Mark:ConfigureMethod
    func configure(name:String,urlString:String) {
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 11)
        nameLabel.textColor = .darkGray
        if urlString == "" {
            teamMemberImage.image = UIImage(named: "noImages")
        } else {
            let url = URL(string: urlString)
            teamMemberImage.sd_setImage(with: url, completed: nil)
        }
    }
}
