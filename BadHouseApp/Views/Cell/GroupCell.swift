import Foundation
import UIKit
import SDWebImage
import Firebase

class GroupCell:UITableViewCell {
 
    //Mark:Properties
    @IBOutlet weak var cellImagevView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var team:TeamModel? {
        didSet {
            configure()
        }
    }
    
    var user:User? {
        didSet {
            userconfigure()
        }
    }
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    //Mark: LifeCycle
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.cellImagevView.layer.cornerRadius = 30
        self.cellImagevView.layer.masksToBounds = true
        self.cellImagevView.contentMode = .scaleAspectFill
        self.accessoryType = .disclosureIndicator
        self.label.font = UIFont.boldSystemFont(ofSize: 16)
        self.selectionStyle = .none
    }
    
    //Mark: nibMethod
    static func nib() ->UINib {
        return UINib(nibName: Utility.Cell.GroupCell, bundle: nil)
    }
    
    func configure() {
        guard let team = team else { return }
        self.label.text = team.teamName
        let url = URL(string: team.teamImageUrl)
        self.cellImagevView.sd_setImage(with: url, completed: nil)
        self.cellImagevView.contentMode = .scaleAspectFill
        self.cellImagevView.chageCircle()
    }
    
    func userconfigure() {
        guard let user = user else { return }
        self.label.text = user.name
        let url = URL(string: user.profileImageUrl)
        if user.profileImageUrl == "" {
            self.cellImagevView.image = UIImage(named: "noImages")
        } else {
        self.cellImagevView.sd_setImage(with: url, completed: nil)
        }
        self.cellImagevView.chageCircle()
    }
    
    func setTimeLabelandCommentLabel(chat:Chat) {
        let text = chat.text
        let date = chat.sendTime
        self.commentLabel.text = text
        if  date != nil {
            if let safeTimeStamp = date {
                let safeDate = safeTimeStamp.dateValue()
                let dateText = self.formatter.string(from: safeDate)
                self.timeLabel.text = dateText
                self.timeLabel.isHidden = false
            }
        }
    }
    
   
    
}
