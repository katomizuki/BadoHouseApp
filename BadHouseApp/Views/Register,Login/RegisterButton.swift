import Foundation
import UIKit

class RegisterButton:UIButton {
    
    //Mark:initialize
    init(text:String) {
        super.init(frame: .zero)
        setTitle(text, for: UIControl.State.normal)
        backgroundColor = Utility.AppColor.OriginalBlue
        setTitleColor(.white, for: UIControl.State.normal)
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
