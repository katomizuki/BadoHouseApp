import Foundation
import UIKit
import FacebookCore

class InfoCollectionViewCell: UICollectionViewCell {
    // Mark Properties
    var user: User? {
        didSet {
            nameTextField.text = user?.name
            emailTextField.text = user?.email
            introductionTextField.text = user?.introduction
        }
    }
    private let nameLabel = ProfileLabel(title: "名前")
    private let emailLabel = ProfileLabel(title: "メールアドレス")
    private let introductionLabel = ProfileLabel(title: "自己紹介")
    let nameTextField = ProfileTextField(placeholder: "名前")
    let emailTextField = ProfileTextField(placeholder: "メールアドレス")
    let introductionTextField = ProfileTextField(placeholder: "自己紹介")
    // Mark Initialize
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let views = [[nameLabel, nameTextField], [emailLabel, emailTextField], [introductionLabel, introductionTextField]]
        let stackViews = views.map { (views) -> UIStackView in
            guard let label = views.first as? UILabel,
                  let textField = views.last as? UITextField else { return UIStackView() }
            let stackView = UIStackView(arrangedSubviews: [label, textField])
            stackView.axis = .vertical
            stackView.spacing = 5
            textField.anchor(height: 50)
            return stackView
        }
        let baseStackView = UIStackView(arrangedSubviews: stackViews)
        baseStackView.axis = .vertical
        baseStackView.spacing = 15
        addSubview(baseStackView)
        nameTextField.anchor(width: UIScreen.main.bounds.width - 40,
                             height: 80)
        baseStackView.anchor(top: topAnchor,
                             bottom: bottomAnchor,
                             left: leftAnchor,
                             right: rightAnchor,
                             paddingTop: 10,
                             paddingBottom: 20,
                             paddingRight: 20)
        backgroundColor = UIColor(named: Constants.AppColor.darkColor)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
