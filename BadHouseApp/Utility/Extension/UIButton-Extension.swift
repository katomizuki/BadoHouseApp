import Foundation
import UIKit

extension UIButton {
    func createAuthButton(text: String) -> UIButton {
        self.setTitle(text, for: UIControl.State.normal)
        self.tintColor = Constants.AppColor.OriginalBlue
        self.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return self
    }
    func createProfileTopButton(title: String) -> UIButton {
        self.titleEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.setTitleColor(.white, for: UIControl.State.normal)
        self.backgroundColor = Constants.AppColor.OriginalBlue
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        return self
    }
    func createProfileEditButton() -> UIButton {
        let image = UIImage(systemName: "square.and.pencil")
        self.setImage(image, for: UIControl.State.normal)
        self.layer.cornerRadius = 30
        self.tintColor = .darkGray
        self.imageView?.contentMode = .scaleToFill
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        return self
    }
    func createTagButton(title: String) -> UIButton {
        self.layer.cornerRadius = 15
        self.tintColor = .darkGray
        self.layer.borderWidth = 4
        self.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        self.layer.masksToBounds = true
        self.setTitle(title, for: UIControl.State.normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.setTitleColor(Constants.AppColor.OriginalBlue, for: UIControl.State.normal)
        return self
    }
    func cretaTagButton(text: String) -> UIButton {
        self.setTitle(text, for: .normal)
        self.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        self.setTitleColor(.systemGray, for: .normal)
        self.isEnabled = false
        return self
    }
    func updateUI(title: String) {
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(.white, for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    func updateSaveButton() {
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    func updateBackButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    func updateButton(radius: CGFloat, backColor: UIColor, titleColor: UIColor, fontSize: CGFloat) {
        self.toCorner(num: radius)
        titleLabel?.font = .boldSystemFont(ofSize: fontSize)
        layer.backgroundColor = backColor.cgColor
        setTitleColor(titleColor, for: .normal)
    }
    func tagButton() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        layer.borderWidth = 2
        setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        titleLabel?.numberOfLines = 0
    }
    func updateSavebutton() {
       backgroundColor = Constants.AppColor.OriginalBlue
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        titleLabel?.font = .boldSystemFont(ofSize: 20)
    }
    func updateBackbutton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
    func updateFriendButton() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitleColor(.systemGray6, for: .normal)
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
    }
    func plusFriendButton() {
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitle(" 友達解除 ", for: .normal)
        setTitleColor(.white, for: .normal)
    }
    func removeFriendButton() {
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        setTitle(" 友達申請 ", for: .normal)
        setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        layer.borderWidth = 4
    }
    func tapRemoveFriend() {
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitle(" 友達解除 ", for: .normal)
        setTitleColor(.white, for: .normal)
    }
    func tapPlusFriend() {
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
}
// Mark UIView-Extension
extension UIView {
    func toCorner(num: CGFloat) {
        layer.cornerRadius = num
        layer.masksToBounds = true
    }
}
