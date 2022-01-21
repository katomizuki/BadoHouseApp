import UIKit

extension UIView {
    func changeCorner(num: Int) {
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(num)
    }
}
