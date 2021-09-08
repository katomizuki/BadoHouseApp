

import Foundation
import UIKit

class ProfileImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.image = UIImage(systemName: "person")
        self.contentMode = .scaleToFill
        self.layer.cornerRadius = frame.width / 2
        self.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        self.layer.borderWidth = 4
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
