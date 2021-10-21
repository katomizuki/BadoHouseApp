import Foundation
import UIKit

class ProfileLabel: UILabel {
    // Mark initialize
    init() {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 45, weight: .bold)
        self.textColor = .black
    }
    init(title: String) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = .systemGray
        self.font = .boldSystemFont(ofSize: 14)
    }
    init(title: String, num: CGFloat) {
        super.init(frame: .zero)
        self.text = title
        self.textColor = .systemGray
        self.textAlignment = .center
        self.font = .boldSystemFont(ofSize: num)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
