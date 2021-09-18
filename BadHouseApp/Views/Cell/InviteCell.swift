import Foundation
import UIKit

class ContactCell:UITableViewCell {
    
    //Mark:Properties
    var linkFriend:FriendsViewController!
    var count = 0
    private var button:UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setImage(UIImage(named: "circle"), for: UIControl.State.normal)
        return button
    }()
    
    //Mark: initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = button
        button.addTarget(self, action: #selector(handleInvite), for: UIControl.Event.touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //Mark: selector
    @objc private func handleInvite() {
        if count % 2 == 0 {
            button.setImage(UIImage(named: "check"), for: UIControl.State.normal)
            self.backgroundColor = Utility.AppColor.OriginalLightBlue
            count += 1
        } else {
            button.setImage(UIImage(named: "circle"), for: UIControl.State.normal)
            self.backgroundColor = .clear
            count += 1
        }
        linkFriend?.someMethodWantToCall(cell: self)
    }
}
