import UIKit

final class AppExplainController: UIViewController {
// MARK: - Properties
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.appName
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "このアプリはB版となります。\n もし,ご質問、不適切な投稿が確認できた場合は、下記のTwitterアカウントにご連絡ください。\n また、このアプリは現在地から近い順に練習を表示させるために位置情報を使用させていただいております。"
        textView.font = .systemFont(ofSize: 15)
//        textView.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private let accessLabel: UILabel = {
        let label = UILabel()
        label.text = "連絡先@katopan0405"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - SetupMethod
    private func setupUI() {
//        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        let stackView = UIStackView(arrangedSubviews: [explainLabel,
                                                       textView,
                                                       accessLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 40,
                         paddingBottom: 10,
                         paddingRight: 10,
                         paddingLeft: 10)
    }
}
