
import Foundation
import UIKit
import SDWebImage

class TeammemberCell:UICollectionViewCell {
    
    
    var teamMember = [User]()
    
    @IBOutlet weak var teamMemberImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static func nib()->UINib {
        return UINib(nibName:Utility.Cell.TeammemberCell, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        teamMemberImage.chageCircle()
    }
    
    func configure(name:String,urlString:String) {
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 11)
        nameLabel.textColor = .darkGray
        if urlString == "" { return }
        let url = URL(string: urlString)
        teamMemberImage.sd_setImage(with: url, completed: nil)
        
    }
  
}
