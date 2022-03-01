import UIKit

extension UIView {
    func changeCorner(num: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = num
    }
}
