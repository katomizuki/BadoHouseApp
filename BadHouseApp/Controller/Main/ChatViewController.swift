import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    private let cellId = "cellId"
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    private var messages = [Chat]()
    var me: User?
    var you: User?
    private let fetchData = FetchFirestoreData()
    private var chatId = String()
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        let nib = ChatCell.nib()
        chatTableView.register(nib, forCellReuseIdentifier: cellId)
        chatTableView.backgroundColor = .lightGray
        chatTextView.delegate = self
        chatTextView.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        chatTextView.layer.borderWidth = 1
        chatTextView.layer.masksToBounds = true
        chatTextView.layer.cornerRadius = 15
        chatTextView.autoresizingMask = .flexibleHeight
        chatTextView.invalidateIntrinsicContentSize()
        fetchData.chatDelegate = self
        guard let myId = me?.uid else { return }
        guard let youId = you?.uid else { return }
        fetchData.getChatData(meId: myId, youId: youId) { chatId in
            print("🍰")
            if chatId.isEmpty {
                print("🎂")
                //初めてこの人と話す場合
                Firestore.sendChatroom(myId: myId, youId: youId) { id in
                    self.chatId = id
                }
            } else {
                self.fetchData.getChat(chatId: chatId)
                self.chatId = chatId
            }
        }
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
}

extension ChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        cell.message = messages[indexPath.row].text
        let id = messages[indexPath.row].senderId
        if id == Auth.getUserId() {
            cell.userImageView.isHidden = true
            let urlString = me?.profileImageUrl ?? ""
            let url = URL(string: urlString)
            cell.myImageView.sd_setImage(with: url, completed: nil)
        } else {
            cell.myImageView.isHidden = true
            let urlString = you?.profileImageUrl ?? ""
            let url = URL(string: urlString)
            cell.userImageView.sd_setImage(with: url, completed: nil)
        }
        let date = messages[indexPath.row].sendTime.dateValue()
        let dateText = self.formatter.string(from: date)
        cell.timeLabel.text = dateText
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}

extension ChatViewController :GetChatDataDelgate {
    func getChatData(chatArray: [Chat]) {
        self.messages = []
        self.messages = chatArray
        chatTableView.reloadData()
    }
    
    
}

