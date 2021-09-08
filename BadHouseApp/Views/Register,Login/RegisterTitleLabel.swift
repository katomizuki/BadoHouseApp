

import Foundation
import UIKit

class RegisterTitleLabel:UILabel {
    
    init(text:String) {
        super.init(frame:.zero)
        self.text  = text
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 80)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
