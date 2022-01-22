import Foundation
import UIKit

protocol RuleControllerDelegate: AnyObject {
    func didTapBackButton(_ vc: RuleController)
}
final class RuleController: UIViewController {
    weak var delegate: RuleControllerDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let textview: UITextView = {
        let tv = UITextView()
        tv.showsVerticalScrollIndicator = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .label
        tv.changeCorner(num: 8)
        tv.isSelectable = false
        tv.isEditable = false
        tv.text = R.appRule
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        view.addSubview(textview)
        textview.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        bottom: view.bottomAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingTop: 0,
                        paddingBottom: 10,
                        paddingRight: 20,
                        paddingLeft: 20)
    }
    
    @objc private func back() {
        print(#function)
        self.delegate?.didTapBackButton(self)
    }
}
