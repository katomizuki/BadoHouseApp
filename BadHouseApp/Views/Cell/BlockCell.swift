import Foundation
import UIKit
import SkeletonView

final class BlockCell: UITableViewCell {
    // MARK: - Properties
    private let cancleLabel: UILabel = {
        let label = UILabel()
        label.text = " 閉じる "
        label.textColor = Constants.AppColor.OriginalBlue
        label.font = .boldSystemFont(ofSize: 18)
        label.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
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
        label.textColor = Constants.AppColor.OriginalBlue
        label.font = .boldSystemFont(ofSize: 18)
        label.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        label.layer.borderWidth = 3
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupMethod
    private func setupUI(bool: Bool) {
        if bool {
            addSubview(cancleLabel)
            cancleLabel.anchor(centerX: centerXAnchor,
                               centerY: centerYAnchor,
                               width: 140,
                               height: 45)
        } else {
            addSubview(blockLabel)
            blockLabel.anchor(centerX: centerXAnchor,
                              centerY: centerYAnchor,
                              width: 140,
                              height: 45)
        }
    }
}
