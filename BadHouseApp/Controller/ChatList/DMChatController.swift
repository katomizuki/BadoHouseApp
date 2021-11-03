import UIKit
import Firebase

final class DMChatController: UIViewController {
    // MARK: - Properties
    private let cellId = Constants.CellId.chatCellId
    @IBOutlet private weak var chatTableView: UITableView!
    private var messages = [Chat]()
    var me: User?
    var you: User?
    var flag = false
    private let fetchData = FetchFirestoreData()
    private var chatId = String()
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: view.frame.width,
                                                        height: 50))
        iv.delegate = self
        return iv
    }()
    override var inputAccessoryView: UIView? {
        return customInputView
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        customInputView.messageInputTextView.resignFirstResponder()
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
        setupData()
        navigationItem.title = you?.name
    }
    // MARK: - SetupMethod
    private func setupData() {
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        ChatRoomService.getChatData(meId: myId, youId: youId) { chatId in
            if chatId.isEmpty {
                ChatRoomService.sendChatroom(myId: myId, youId: youId) { [weak self] id in
                    guard let self = self else { return }
                    self.chatId = id
                }
            } else {
                self.fetchData.fetchDMChatData(chatId: chatId)
                self.chatId = chatId
            }
        }
    }
    // MARK: - updatechatTextView
    private func setupTextView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        let nib = ChatCell.nib()
        chatTableView.register(nib, forCellReuseIdentifier: cellId)
        fetchData.chatDelegate = self
    }
}
// MARK: - UITableViewDataSource
extension DMChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        guard let you = you else { return cell }
        guard let me = me else { return cell }
        cell.dmchatCel(chat: messages[indexPath.row], bool: messages[indexPath.row].senderId == me.uid, you: you)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension DMChatController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - FetchChatDataDelgate
extension DMChatController: FetchChatDataDelgate {
    func fetchMyChatData(chatArray: [Chat]) {
        self.messages = []
        self.messages = chatArray
        self.chatTableView.reloadData()
        if messages.count != 0 {
            chatTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0),
                                      at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
// MARK: - InputDelegate
extension DMChatController: InputDelegate {
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        print(#function)
        guard let text = inputView.messageInputTextView.text else { return }
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        if text == "" { return }
        inputView.messageInputTextView.text = ""
        ChatRoomService.sendDMChat(chatroomId: chatId,
                                   senderId: myId,
                                   text: text,
                                   reciverId: youId) { result in
            switch result {
            case .success:
                self.fetchData.fetchDMChatData(chatId: self.chatId)
                inputView.messageInputTextView.resignFirstResponder()
            case .failure(let error):
                let message = self.setupFirestoreErrorMessage(error: error as! NSError)
                self.setupCDAlert(title: "メッセージの送信に失敗しました",
                                  message: message,
                                  action: "OK",
                                  alertType: .warning)
            }
        }
    }
}
