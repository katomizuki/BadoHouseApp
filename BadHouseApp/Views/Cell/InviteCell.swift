import Foundation
import UIKit

final class InviteCell: UITableViewCell {
    // MARK: - Properties
    var linkFriend: InviteToCircleController!
    var count = 0
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: 50,
                              height: 50)
        let image = UIImage(named: "circle-1")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
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
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        accessoryView = button
        button.addTarget(self, action: #selector(handleInvite), for: .touchUpInside)
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
        fatalError()
    }
    // MARK: - selector
    @objc private func handleInvite() {
        button.tintColor = Constants.AppColor.OriginalBlue
        if count % 2 == 0 {
            button.setImage(UIImage(named: Constants.ImageName.check), for: .normal)
            count += 1
        } else {
            button.setImage(UIImage(named: Constants.ImageName.circle), for: .normal)
            count += 1
        }
        linkFriend?.someMethodWantToCall(cell: self)
    }
}
