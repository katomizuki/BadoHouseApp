import Foundation
import UIKit

class RegisterTextField: UITextField {
    // Mark initialize
    init(placeholder: String) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.font = .systemFont(ofSize: 14)
        self.autocapitalizationType = .none
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.darkGray
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
