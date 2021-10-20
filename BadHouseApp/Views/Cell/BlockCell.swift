import Foundation
import UIKit

class BlockCell: UITableViewCell {
    // Mark Properties
    private let cancleLabel: UILabel = {
        let label = UILabel()
        label.text = " 閉じる "
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    var flag = false {
        didSet {
            setupUI(bool: flag)
        }
    }
    private let blockLabel: UILabel = {
        let label = UILabel()
        label.text = " 通報する　"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    // Mark Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Constants.AppColor.OriginalBlue
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Mark setupMethod
    private func setupUI(bool: Bool) {
        if bool {
            addSubview(blockLabel)
            blockLabel.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
        } else {
            addSubview(cancleLabel)
            cancleLabel.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
        }
    }
}
