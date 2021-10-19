import UIKit
import Firebase
import SDWebImage

class GroupChatViewController: UIViewController {
    //Mark:Properties
    var team:TeamModel?
    private var chatArray = [GroupChatModel]()
    @IBOutlet private weak var tableView: UITableView!
    private let cellId = Constants.CellId.chatCellId
    private let fetchData = FetchFirestoreData()
    private var me:User?
    private lazy var customInputView:CustomInputAccessoryView = {
        let ci = CustomInputAccessoryView(frame: CGRect(x:0,y:0,width:view.frame.width,height:50))
        ci.delegate = self
        return ci
    }()
    
    override var inputAccessoryView: UIView? {
        get{ return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //Mark lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        view.backgroundColor = .white
    }
    //Mark setupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = ChatCell.nib()
        tableView.separatorStyle = .none
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    private func setupData() {
        UserService.getUserData(uid: AuthService.getUserId()) { [weak self] me in
            guard let self = self else { return }
            self.me = me
        }
        guard let teamId = team?.teamId else { return }
        fetchData.getGroupChat(teamId: teamId)
        fetchData.groupChatDataDelegate = self
    }
}
//Mark :tableViewdelegate
extension GroupChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        cell.configure(chat: chatArray[indexPath.row],bool:self.chatArray[indexPath.row].senderId == AuthService.getUserId())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
//Mark:chatDelegate
extension GroupChatViewController:GetGroupChatDelegate {
    func getGroupChat(chatArray: [GroupChatModel]) {
        self.chatArray = []
        self.chatArray = chatArray
        self.tableView.reloadData()
        if chatArray.count != 0 {
            tableView.scrollToRow(at: IndexPath(row: chatArray.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated:true)
        }
    }
}
//Mark InputDelegate
extension GroupChatViewController:InputDelegate {
    
    func inputView(inputView: CustomInputAccessoryView, message: String) {
        guard let teamId = self.team?.teamId else { return }
        guard let me = self.me else { return }
        guard let text = inputView.messageInputTextView.text else { return }
        if text == "" { return }
        Firestore.sendGroupChat(teamId: teamId, me: me, text: text)
        inputView.messageInputTextView.text = ""
    }
}
