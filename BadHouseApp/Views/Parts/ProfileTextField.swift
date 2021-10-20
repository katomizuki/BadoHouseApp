import Foundation
import UIKit

class ProfileTextField:UITextField {
    
    //Mark:initialize
    init(placeholder:String) {
        super.init(frame:.zero)
        self.borderStyle = .bezel
        self.placeholder = placeholder
        self.backgroundColor = UIColor(named: "TFColor")
        self.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

