import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    //Mark:Properties
    private let cellId = "cellId"
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    private var messages = [Chat]()
    var me: User?
    var you: User?
    var flag = false
    private let fetchData = FetchFirestoreData()
    private var chatId = String()
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var subNav: UINavigationBar!
    
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()
        getData()
        updateUI()
        backButton.isHidden = flag
        subNav.isHidden = flag
        sendButton.isEnabled = false
    }
    
    //Mark:updateUI
    private func updateUI() {
        sendButton.layer.cornerRadius = 15
        sendButton.layer.masksToBounds = true
        navigationItem.title = you?.name
        subNav.topItem?.title = you?.name
    }
    
    //Mark:getData
    private func getData() {
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        fetchData.getChatData(meId: myId, youId: youId) { chatId in
            if chatId.isEmpty {
                Firestore.sendChatroom(myId: myId, youId: youId) { id in
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
        chatTextView.delegate = self
        chatTextView.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        chatTextView.layer.borderWidth = 1
        chatTextView.layer.masksToBounds = true
        chatTextView.layer.cornerRadius = 15
        chatTextView.autoresizingMask = .flexibleHeight
        chatTextView.invalidateIntrinsicContentSize()
        fetchData.chatDelegate = self
 
    }
    
    //Mark :IBAction
    @IBAction func send(_ sender: Any) {
        print(#function)
        guard let text = chatTextView.text else { return }
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        chatTextView.text = ""
        sendButton.isEnabled = false
        Firestore.sendChat(chatroomId: self.chatId, senderId: myId, text: text,reciverId: youId)
        fetchData.getChat(chatId: chatId)
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

//Mark:UITableViewDelegate,DataSource
extension ChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        guard let date = messages[indexPath.row].sendTime?.dateValue() else { return cell }
        let dateText = self.formatter.string(from: date)
        let text = messages[indexPath.row].text
        let id = messages[indexPath.row].senderId
        if id == Auth.getUserId() {
            cell.userImageView.isHidden = true
            cell.timeLabel.isHidden = true
            cell.textView.isHidden = true
            cell.mytimeLabel.isHidden = false
            cell.mytextView.isHidden = false
            cell.mytimeLabel.text = dateText
            cell.mytextView.text = text
        } else {
            let urlString = you?.profileImageUrl ?? ""
            let url = URL(string: urlString)
            cell.userImageView.sd_setImage(with: url, completed: nil)
            cell.mytextView.isHidden = true
            cell.mytimeLabel.isHidden = true
            cell.userImageView.isHidden = false
            cell.textView.isHidden = false
            cell.timeLabel.isHidden = false
            cell.timeLabel.text = dateText
            cell.textView.text = text
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

//Mark:UItextViewDelegate
extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}

//Mark:GetChatDelegate
extension ChatViewController: GetChatDataDelgate {
    
    func getChatData(chatArray: [Chat]) {
        self.messages = []
        self.messages = chatArray
        chatTableView.reloadData()
        if messages.count != 0 {
        chatTableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated:true)
        }
    }
    
}

