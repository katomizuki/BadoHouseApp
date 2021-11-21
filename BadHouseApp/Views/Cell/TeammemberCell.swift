import Foundation
import UIKit
import SDWebImage
import FacebookCore

final class TeammemberCell: UICollectionViewCell {
    // MARK: - Properties
    var teamMember = [User]()
    @IBOutlet weak var teamMemberImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // MARK: - nib
    static func nib() -> UINib {
        return UINib(nibName: "TeammemberCell", bundle: nil)
    }
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        teamMemberImage.layer.cornerRadius = 30
        teamMemberImage.layer.masksToBounds = true
        teamMemberImage.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        teamMemberImage.layer.borderWidth = 2
        teamMemberImage.contentMode = .scaleAspectFill
        teamMemberImage.clipsToBounds = true
    }
    // MARK: - HelperMethod
    func configure(name: String, url: String) {
        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: 11)
        nameLabel.textColor = .darkGray
        if url == "" {
            teamMemberImage.image = UIImage(named: Constants.ImageName.noImages)
        } else {
            let url = URL(string: url)
            teamMemberImage.sd_setImage(with: url, completed: nil)
        }
    }
}
