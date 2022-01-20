import UIKit

extension UIImageView {
    func chageCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 4
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}
