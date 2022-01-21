import UIKit

extension UITextField {
    func setUnderLine(width: CGFloat) {
        borderStyle = .none
        let underLine = UIView()
        underLine.backgroundColor = .darkGray
        addSubview(underLine)
        underLine.anchor(bottom: bottomAnchor,
               leading: leadingAnchor,
               trailing: trailingAnchor,
               height: 1)
    }
}
