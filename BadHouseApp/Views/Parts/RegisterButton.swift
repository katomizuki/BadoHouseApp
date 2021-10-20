import Foundation
import UIKit

class RegisterButton: UIButton {
    // Mark initialize
    init(text: String) {
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        backgroundColor = Constants.AppColor.OriginalBlue
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
