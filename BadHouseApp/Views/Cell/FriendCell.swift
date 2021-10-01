import Foundation
import UIKit
import FacebookCore

class FriendsCell:UITableViewCell {
    
    //Mark:Properties
    var linkInvite:InviteViewController!
    var count = 0
    private var button:UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setImage(UIImage(named: Utility.ImageName.circle), for: UIControl.State.normal)
        return button
    }()
    
    var iv:UIImageView = {
       let iv = UIImageView()
       return iv
   }()
   var nameLabel:UILabel = {
       let label = UILabel()
       return label
   }()
    
    //Mark: initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.iv.layer.cornerRadius = 25
        self.iv.layer.masksToBounds = true
        accessoryView = button
        button.addTarget(self, action: #selector(handleInvite), for: UIControl.Event.touchUpInside)
        self.addSubview(iv)
        self.addSubview(nameLabel)
        iv.anchor(top:self.topAnchor,left: self.leftAnchor,paddingTop: 10,paddingLeft: 10,width: 50,height: 50)
        nameLabel.anchor(top:self.topAnchor,left: iv.rightAnchor,paddingTop: 20,paddingLeft: 10,height: 25)
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    
    //Mark: selector
    @objc private func handleInvite() {
        if count % 2 == 0 {
            button.setImage(UIImage(named: Utility.ImageName.check), for: UIControl.State.normal)
            self.backgroundColor = Utility.AppColor.OriginalBlue
            count += 1
        } else {
            button.setImage(UIImage(named: Utility.ImageName.circle), for: UIControl.State.normal)
            count += 1
        }
        linkInvite?.someMethodWantToCall(cell: self)
    }
}
