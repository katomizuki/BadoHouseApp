import UIKit

protocol UserProfileHeaderViewDelegate: AnyObject {
    func didTapSearchButton(option: UserProfileSelection)
   func didTapPlusTeamButton()
    func didTapApplyButton()
}

final class UserProfileHeaderView: UITableViewHeaderFooterView {
    
    static let id = String(describing: self)
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = R.label.circle
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let searchButton: UIButton = {
            let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: R.SFSymbols.magnifying), for: .normal)
        button.setTitle(R.buttonTitle.searchCircle, for: .normal)
            button.tintColor = .systemBlue
            return button
    }()
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: R.SFSymbols.plus), for: .normal)
        button.setTitle(R.buttonTitle.makeCircle, for: .normal)
            button.tintColor = .systemBlue
            return button
    }()
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: R.SFSymbols.person3), for: .normal)
        button.setTitle(R.buttonTitle.applyedUser, for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    weak var delegate: UserProfileHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(headerLabel)
        contentView.addSubview(searchButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(applyButton)
        applyButton.isHidden = true
        headerLabel.anchor(leading: contentView.leadingAnchor,
                           paddingLeft: 10,
                           centerY: contentView.centerYAnchor)
        searchButton.anchor(leading: headerLabel.trailingAnchor,
                            paddingLeft: 10,
                            centerY: contentView.centerYAnchor)
        plusButton.anchor(leading: searchButton.trailingAnchor,
                          paddingLeft: 10,
                          centerY: contentView.centerYAnchor)
        applyButton.anchor(leading: searchButton.trailingAnchor,
                           paddingLeft: 10,
                           centerY: contentView.centerYAnchor)
        let searchAction = UIAction { _ in
            self.delegate?.didTapSearchButton(option: self.headerLabel.text == R.label.friends ? .user : .circle)
        }
        let plusAction = UIAction { _ in
            self.delegate?.didTapPlusTeamButton()
        }
        let applyAction = UIAction { _ in
            self.delegate?.didTapApplyButton()
        }
        searchButton.addAction(searchAction, for: .primaryActionTriggered)
        plusButton.addAction(plusAction, for: .primaryActionTriggered)
        applyButton.addAction(applyAction, for: .primaryActionTriggered)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(_ section: Int) {
        if section == 1 {
            headerLabel.text = R.label.friends
            searchButton.setTitle(R.buttonTitle.searchFriends, for: .normal)
            plusButton.isHidden = true
            applyButton.isHidden = false
        } else if section == 0 {
            headerLabel.text = R.label.circle
            searchButton.setTitle(R.buttonTitle.searchCircle, for: .normal)
            plusButton.isHidden = false
            applyButton.isHidden = true
        }
    }
}
