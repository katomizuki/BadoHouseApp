
import Foundation
import UIKit

class ProfileLabel:UILabel{
    
    init() {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: 45,weight: .bold)
        self.textColor = .black
    }
    
    init(title:String) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = .black
        self.font = .boldSystemFont(ofSize: 14)
    }
    
    init(title:String,num:CGFloat) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = .black
        self.textAlignment = .center
        self.font = .boldSystemFont(ofSize: num)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
