import Foundation
import UIKit

class FriendSearchCell: UITableViewCell {
    
    var link:FriendSSearchViewController!
    var count = 0
    
    private var button:UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        button.setTitle( "　ともだちになる　", for: UIControl.State.normal)
        button.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        button.layer.borderWidth = 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.iv.layer.cornerRadius = 25
        self.iv.layer.masksToBounds = true
        accessoryView = button
        button.addTarget(self, action: #selector(plusFriend), for: UIControl.Event.touchUpInside)
        self.addSubview(iv)
        self.addSubview(nameLabel)
        iv.anchor(top:self.topAnchor,left: self.leftAnchor,paddingTop: 10,paddingLeft: 10,width: 50,height: 50)
        nameLabel.anchor(top:self.topAnchor,left: iv.rightAnchor,paddingTop: 20,paddingLeft: 10,height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func plusFriend() {
        print(#function)
        
        if count % 2 == 0 {
            button.backgroundColor = Utility.AppColor.OriginalBlue
            button.setTitleColor(.white, for: UIControl.State.normal)
            button.setTitle("　友だち追加済　", for: UIControl.State.normal)
        } else  {
            button.backgroundColor = .white
            button.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
            button.layer.borderWidth = 3
            button.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
            button.setTitle("　友だちになる　", for: UIControl.State.normal)
        }
        count += 1
        link?.method(cell: self)
    }
    
}
