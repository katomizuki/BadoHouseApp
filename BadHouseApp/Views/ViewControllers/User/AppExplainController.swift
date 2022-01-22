import UIKit

final class AppExplainController: UIViewController {
// MARK: - Properties
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = R.appName
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .label
        return label
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = R.appExplain
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    private let accessLabel: UILabel = {
        let label = UILabel()
        label.text = R.address
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
        let stackView = UIStackView(arrangedSubviews: [explainLabel,
                                                       textView,
                                                       accessLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: 40,
                         paddingBottom: 10,
                         paddingRight: 10,
                         paddingLeft: 10)
    }
}
