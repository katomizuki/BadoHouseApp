

import Foundation
import UIKit

class ProfileTextField:UITextField {
    init(placeholder:String) {
        super.init(frame:.zero)
        self.borderStyle = .bezel
        self.placeholder = placeholder
        self.backgroundColor = .rgb(red: 245, green: 245, blue: 245)
        self.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
import Foundation
