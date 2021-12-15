import UIKit
import SwiftUI
protocol BlockDismissDelegate: AnyObject {
    func blockDismiss(vc: BlockController)
}
final class BlockController: UIViewController {
    // MARK: - Properties
    let blockTextView = BlockTextView()
    weak var delegate: BlockDismissDelegate?
    private var user: User?
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("送信する", for: .normal)
        button.setTitleColor(Constants.AppColor.OriginalBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        button.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderWidth = 3
        button.addTarget(self, action: #selector(handlerBlock), for: .touchUpInside)
        return button
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK: - Initialize
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - setupMethod
    private func setupUI() {
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        view.addSubview(blockTextView)
        view.addSubview(sendButton)
        blockTextView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: view.frame.width - 200,
                             height: 200)
        sendButton.anchor(top: blockTextView.bottomAnchor,
                          paddingTop: 20,
                          centerX: view.centerXAnchor,
                          width: view.frame.width - 300,
                          height: 40)
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
    }
    // MARK: - Selector
    @objc private func handlerBlock() {
        print(#function)
        guard let text = blockTextView.text else { return }
        guard let user = user else { return }
        BlockService.sendBlockData(userId: user.uid, reason: text)
        self.delegate?.blockDismiss(vc: self)
    }
    @objc private func back() {
        self.delegate?.blockDismiss(vc: self)
    }
}
