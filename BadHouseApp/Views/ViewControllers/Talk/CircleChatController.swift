import UIKit

final class CircleChatController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private lazy var customInputView: CustomInputAccessoryView = {
        let ci = CustomInputAccessoryView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        ci.delegate = self
        return ci
    }()
    var coordinator:ChatCoordinator?
    override var inputAccessoryView: UIView? {
        return customInputView
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    // MARK: - SetupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ChatCell.nib(), forCellReuseIdentifier: ChatCell.id)
    }
   
}
// MARK: - UITableViewDataSource
extension CircleChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.id, for: indexPath) as? ChatCell else { fatalError() }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CircleChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - InputDelegate
extension CircleChatController: InputDelegate {
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        guard let text = inputView.messageInputTextView.text else { return }
        if text == "" { return }
        inputView.messageInputTextView.text = ""
    }
}
