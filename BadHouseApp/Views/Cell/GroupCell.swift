import Foundation
import UIKit
import SDWebImage
import Firebase
import FacebookCore
import RxSwift
protocol CalendarEventDelegate {
    func removeEvent(eventModel:Event,cell:UITableViewCell)
}
class GroupCell:UITableViewCell {
 
    //Mark:Properties
    @IBOutlet weak var cellImagevView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var trashDelegate:CalendarEventDelegate?
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
    var event:Event? {
        didSet {
            eventConfigure()
        }
    }
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    let trashButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: UIControl.State.normal)
        button.tintColor = Utility.AppColor.OriginalBlue
        return button
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
        addSubview(trashButton)
        trashButton.isHidden = true
        trashButton.anchor(bottom:bottomAnchor,right:rightAnchor,paddingBottom:10, paddingRight: 20,width:30, height: 30)
        trashButton.addTarget(self, action: #selector(handleTrash), for: .touchUpInside)
    }
    
    //Mark: nibMethod
    static func nib() ->UINib {
        return UINib(nibName: Utility.Cell.GroupCell, bundle: nil)
    }
    @objc private func handleTrash() {
        print(#function)
        guard let event = event else {
            return
        }

        self.trashDelegate?.removeEvent(eventModel:event,cell:self)
    }
    
    private func eventConfigure() {
        label.text = event?.eventTitle
        if let dateString = event?.eventStartTime.prefix(16) {
            timeLabel.text = String(dateString)
            timeLabel.isHidden = false
        }
        guard let urlString = event?.teamImageUrl else { return }
        let url = URL(string: urlString)
        cellImagevView.sd_setImage(with: url, completed: nil)
        accessoryType = .none
        trashButton.isHidden = false
        
    }
    
    private func configure() {
        guard let team = team else { return }
        self.label.text = team.teamName
        let url = URL(string: team.teamImageUrl)
        self.cellImagevView.sd_setImage(with: url, completed: nil)
        self.cellImagevView.contentMode = .scaleAspectFill
        self.cellImagevView.chageCircle()
       
    }
    
    private func userconfigure() {
        guard let user = user else { return }
        self.label.text = user.name
        let url = URL(string: user.profileImageUrl)
        if user.profileImageUrl == "" {
            self.cellImagevView.image = UIImage(named: Utility.ImageName.noImages)
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
