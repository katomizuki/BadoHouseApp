//
//  UserProfileHeaderView.swift
//  BadHouseApp
//
//  Created by ミズキ on 2021/12/21.
//

import Foundation
import UIKit
enum UserProfileSelection {
    case circle
    case user
}
protocol UserProfileHeaderViewDelegate: AnyObject {
    func didTapSearchButton(option: UserProfileSelection)
   func didTapPlusTeamButton()
    func didTapApplyButton()
}
final class UserProfileHeaderView: UITableViewHeaderFooterView {
    static let id = String(describing: self)
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "所属サークル"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private let searchButton: UIButton = {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
            button.setTitle("サークルを探す", for: .normal)
            button.tintColor = .systemBlue
            return button
    }()
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
            button.setTitle("サークルを作る", for: .normal)
            button.tintColor = .systemBlue
            return button
    }()
    private let applyButton:UIButton = {
        let button = UIButton(type:.system)
        button.setImage(UIImage(systemName: "person.3"), for: .normal)
        button.setTitle("申請済みのユーザー", for: .normal)
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
            self.delegate?.didTapSearchButton(option: self.headerLabel.text == "バド友" ? .user : .circle)
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
            headerLabel.text = "バド友"
            searchButton.setTitle("バド友を探す", for: .normal)
            plusButton.isHidden = true
            applyButton.isHidden = false
        } else if section == 0 {
            headerLabel.text = "所属サークル"
            searchButton.setTitle("サークルを探す", for: .normal)
            plusButton.isHidden = false
            applyButton.isHidden = true
        }
    }
}
