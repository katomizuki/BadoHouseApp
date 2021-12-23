//
//
//import UIKit
//
//final class CircleChatController: UIViewController {
//    // MARK: - Properties
//    var team: TeamModel?
//    private var chatArray = [GroupChatModel]()
//    @IBOutlet private weak var tableView: UITableView!
//    private let cellId = "chatCellId"
//    private var me: User?
//    private lazy var customInputView: CustomInputAccessoryView = {
//        let ci = CustomInputAccessoryView(frame: CGRect(x: 0,
//                                                        y: 0,
//                                                        width: view.frame.width,
//                                                        height: 50))
//        ci.delegate = self
//        return ci
//    }()
//    override var inputAccessoryView: UIView? {
//        return customInputView
//    }
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupData()
//    }
//    // MARK: - SetupMethod
//    private func setupTableView() {
//        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
//        tableView.delegate = self
//        tableView.dataSource = self
//        let nib = ChatCell.nib()
//        tableView.separatorStyle = .none
//        tableView.register(nib, forCellReuseIdentifier: cellId)
//    }
//    private func setupData() {
//        UserService.getUserData(uid: AuthService.getUserId()) { [weak self] me in
//            guard let self = self else { return }
//            self.me = me
//        }
//        guard let teamId = team?.teamId else { return }
//    }
//}
//// MARK: - UITableViewDataSource
//extension CircleChatController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatArray.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
//        cell.configure(chat: chatArray[indexPath.row], bool: self.chatArray[indexPath.row].senderId == AuthService.getUserId())
//        return cell
//    }
//}
//// MARK: - UITableViewDelegate
//extension CircleChatController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//}
//
//// MARK: - InputDelegate
//extension CircleChatController: InputDelegate {
//    func inputView(inputView: CustomInputAccessoryView, message: String) {
//        guard let teamId = self.team?.teamId else { return }
//        guard let me = self.me else { return }
//        guard let text = inputView.messageInputTextView.text else { return }
//        if text == "" { return }
//        ChatRoomService.sendGroupChat(teamId: teamId, me: me, text: text)
//        inputView.messageInputTextView.text = ""
//    }
//}
