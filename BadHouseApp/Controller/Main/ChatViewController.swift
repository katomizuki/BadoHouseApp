import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    //Mark:Properties
    private let cellId = Utility.CellId.chatCellId
    @IBOutlet private weak var chatTableView: UITableView!
    private var messages = [Chat]()
    var me: User?
    var you: User?
    var flag = false
    private let fetchData = FetchFirestoreData()
    private var chatId = String()
    private lazy var customInputView:CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x:0,y:0,width:view.frame.width,height:50))
        iv.delegate = self
        return iv
    }()
    
    override var inputAccessoryView: UIView? {
        get{ return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        customInputView.messageInputTextView.resignFirstResponder()
    }
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()
        getData()
        updateUI()
    }
    
    //Mark:updateUI
    private func updateUI() {
        navigationItem.title = you?.name
    }
    
    //Mark:getData
    private func getData() {
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        fetchData.getChatData(meId: myId, youId: youId) { chatId in
            if chatId.isEmpty {
                Firestore.sendChatroom(myId: myId, youId: youId) { [weak self] id in
                    guard let self = self else { return }
                    self.chatId = id
                }
            } else {
                self.fetchData.getChat(chatId: chatId)
                self.chatId = chatId
            }
        }
    }
    
    //Mark:updatechatTextView
    private func updateTextView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        let nib = ChatCell.nib()
        chatTableView.register(nib, forCellReuseIdentifier: cellId)
        fetchData.chatDelegate = self
    }
    
}
//Mark:UITableViewDelegate,DataSource
extension ChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        guard let you = you else { return cell }
        guard let me = me else { return cell }
        cell.dmchatCel(chat: messages[indexPath.row], bool: messages[indexPath.row].senderId == me.uid,you:you)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//Mark:GetChatDelegate
extension ChatViewController: GetChatDataDelgate {
    
    func getChatData(chatArray: [Chat]) {
        self.messages = []
        self.messages = chatArray
        self.chatTableView.reloadData()
        if messages.count != 0 {
        chatTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated:true)
        }
    }
}

extension ChatViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
 
}

extension ChatViewController:InputDelegate {
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        print(#function)
        guard let text = inputView.messageInputTextView.text else { return }
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        inputView.messageInputTextView.text = ""
        Firestore.sendChat(chatroomId: self.chatId, senderId: myId, text: text,reciverId: youId)
        fetchData.getChat(chatId: chatId)
        inputView.messageInputTextView.resignFirstResponder()
    }
    
   
}

