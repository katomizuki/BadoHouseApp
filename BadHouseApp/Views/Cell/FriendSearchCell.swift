import Foundation
import UIKit

final class FriendSearchCell: UITableViewCell {
    // MARK: - properties
    var link: FriendSearchController!
    var count = 0
    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 120,
                              height: 50)
        button.setTitle( "　ともだちになる　", for: .normal)
        button.setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        button.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        button.layer.borderWidth = 3
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    var iv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    // MARK: - initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = button
        button.addTarget(self, action: #selector(plusFriend), for: UIControl.Event.touchUpInside)
        self.addSubview(iv)
        self.addSubview(nameLabel)
        iv.anchor(top: self.topAnchor,
                  left: self.leftAnchor,
                  paddingTop: 10,
                  paddingLeft: 10,
                  width: 50,
                  height: 50)
        nameLabel.anchor(top: self.topAnchor,
                         left: iv.rightAnchor,
                         paddingTop: 20,
                         paddingLeft: 10,
                         height: 25)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - selector
    @objc func plusFriend() {
        print(#function)
        if count % 2 == 0 {
            button.backgroundColor = Constants.AppColor.OriginalBlue
            button.setTitleColor(.white, for: .normal)
            button.setTitle("　友だち追加済　", for: .normal)
        } else {
            button.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
            button.setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
            button.layer.borderWidth = 3
            button.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
            button.setTitle("　友だちになる　", for: .normal)
        }
        count += 1
        link?.plusFriend(cell: self)
    }
}
