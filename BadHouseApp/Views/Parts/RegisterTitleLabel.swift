import Foundation
import UIKit

final class RegisterTitleLabel: UILabel {
    // MARK: - initialize
    init(text: String) {
        super.init(frame: .zero)
        self.text  = text
        self.textColor = .white
        self.font = .systemFont(ofSize: 30)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
