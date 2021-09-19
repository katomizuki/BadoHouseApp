import UIKit
import Firebase
import SDWebImage

class GroupChatViewController: UIViewController {
    
    //Mark:Properties
    var team:TeamModel?
    private var chatArray = [GroupChatModel]()
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "cellId"
    private let fetchData = FetchFirestoreData()
    private var me:User?
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja-JP")
        return formatter
    }()
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        Firestore.getUserData(uid: Auth.getUserId()) { me in
            self.me = me
        }
        navBar.topItem?.title = team?.teamName
    }
    
    @IBAction func sendChat(_ sender: Any) {
        guard let teamId = self.team?.teamId else { return }
        guard let me = self.me else { return }
        guard let text = textView.text else { return }
        Firestore.sendGroupChat(teamId: teamId, me: me, text: text)
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
        let date = chatArray[indexPath.row].timeStamp.dateValue()
        let dateText = self.formatter.string(from: date)
        let text = chatArray[indexPath.row].text
        let senderId = self.chatArray[indexPath.row].senderId
        if senderId == Auth.getUserId() {
            cell.userImageView.isHidden = true
            cell.timeLabel.isHidden = true
            cell.textView.isHidden = true
            cell.mytimeLabel.isHidden = false
            cell.mytextView.isHidden = false
            cell.mytimeLabel.text = dateText
            cell.mytextView.text = text
        } else {
            cell.userImageView.isHidden = false
            cell.textView.isHidden = false
            cell.timeLabel.isHidden = false
            cell.mytextView.isHidden = true
            cell.mytimeLabel.isHidden = true
            cell.textView.text = chatArray[indexPath.row].text
            let urlString = chatArray[indexPath.row].senderUrl
            let url = URL(string: urlString)
            cell.userImageView.sd_setImage(with: url, completed: nil)
            cell.timeLabel.text = dateText
        }
        return cell
    }
}

extension GroupChatViewController:GetGroupChatDelegate {
    func getGroupChat(chatArray: [GroupChatModel]) {
        self.chatArray = []
        self.chatArray = chatArray
        tableView.reloadData()
    }
    
    
}
