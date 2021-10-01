import Foundation
import UIKit

extension UIButton {
    
    func createAuthButton(text:String)->UIButton {
        self.setTitle(text, for: UIControl.State.normal)
        self.tintColor = Utility.AppColor.OriginalBlue
        self.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return self
    }
    
    func createProfileTopButton(title:String) -> UIButton {
        self.titleEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.setTitleColor(.white, for: UIControl.State.normal)
        self.backgroundColor = Utility.AppColor.OriginalBlue
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        return self
    }
    
    func createProfileEditButton()->UIButton {
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
    
    func createTagButton(title:String)->UIButton {
        self.layer.cornerRadius = 15
        self.tintColor = .darkGray
        self.layer.borderWidth = 4
        self.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        self.layer.masksToBounds = true
        self.setTitle(title, for: UIControl.State.normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
        return self
    }
    
    func cretaTagButton(text:String)->UIButton {
        self.setTitle(text, for: UIControl.State.normal)
        self.backgroundColor = Utility.AppColor.OriginalBlue
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.setTitleColor(.white, for: UIControl.State.normal)
        self.isEnabled = false
        return self
    }
    
    func updateUI(title:String) {
        backgroundColor = Utility.AppColor.OriginalBlue
        setTitle(title, for: UIControl.State.normal)
        setTitleColor(.white, for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    func updateSaveButton() {
        backgroundColor = Utility.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func updateBackButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        backgroundColor = Utility.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func updateButton(radius:CGFloat,backColor:UIColor,titleColor:UIColor,fontSize:CGFloat) {
        self.toCorner(num: radius)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        layer.backgroundColor = backColor.cgColor
        setTitleColor(titleColor, for: .normal)
    }
    
    func tagButton() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        layer.borderWidth = 2
        setTitleColor(Utility.AppColor.OriginalBlue, for: UIControl.State.normal)
        backgroundColor = .white
        titleLabel?.numberOfLines = 0
    }
    
    func updateSavebutton() {
       backgroundColor = Utility.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func updateBackbutton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        backgroundColor = Utility.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
  
    
   
}

extension UIView {
    func toCorner(num:CGFloat) {
        layer.cornerRadius = num
        layer.masksToBounds = true
    }
}
