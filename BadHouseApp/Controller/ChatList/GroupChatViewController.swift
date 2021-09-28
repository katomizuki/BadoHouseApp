import UIKit
import Firebase
import SDWebImage

class GroupChatViewController: UIViewController {
    
    //Mark:Properties
    var team:TeamModel?
    private var chatArray = [GroupChatModel]()

    @IBOutlet weak var tableView: UITableView!
    private let cellId = Utility.CellId.chatCellId
    private let fetchData = FetchFirestoreData()
    private var me:User?
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja-JP")
        return formatter
    }()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        view.backgroundColor = .white
        Firestore.getUserData(uid: Auth.getUserId()) { me in
            self.me = me
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = ChatCell.nib()
        tableView.separatorStyle = .none
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    private func setupData() {
        guard let teamId = team?.teamId else { return }
        fetchData.getGroupChat(teamId: teamId)
        fetchData.groupChatDataDelegate = self
    }
    

}

extension GroupChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
       cell.configure(chat: chatArray[indexPath.row],bool:self.chatArray[indexPath.row].senderId == Auth.getUserId())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension GroupChatViewController:GetGroupChatDelegate {
    func getGroupChat(chatArray: [GroupChatModel]) {
        self.chatArray = []
        self.chatArray = chatArray
        tableView.reloadData()
        if chatArray.count != 0 {
        tableView.scrollToRow(at: IndexPath(row: chatArray.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated:true)
        }
    }
}

extension GroupChatViewController:InputDelegate {
    
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        guard let teamId = self.team?.teamId else { return }
        guard let me = self.me else { return }
        guard let text = inputView.messageInputTextView.text else { return }
        Firestore.sendGroupChat(teamId: teamId, me: me, text: text)
        inputView.messageInputTextView.text = ""
    }
    
    
}
