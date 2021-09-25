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
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        updateUI()
        
        Firestore.getUserData(uid: Auth.getUserId()) { me in
            self.me = me
        }
        navBar.topItem?.title = team?.teamName
    }
    
    private func updateUI() {
        textView.layer.cornerRadius = 15
        textView.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 15
        sendButton.layer.masksToBounds = true
    }
    
    @IBAction func sendChat(_ sender: Any) {
        guard let teamId = self.team?.teamId else { return }
        guard let me = self.me else { return }
        guard let text = textView.text else { return }
        Firestore.sendGroupChat(teamId: teamId, me: me, text: text)
        textView.text = ""
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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension GroupChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        guard let date = chatArray[indexPath.row].timeStamp?.dateValue() else { return cell }
        let dateText = self.formatter.string(from: date)
        let text = chatArray[indexPath.row].text
        cell.mytextView.font = UIFont(name: "Kailasa", size: 14)
        cell.textView.font = UIFont(name: "Kailasa", size: 14)
        let dateTextFirst = String(dateText.suffix(11))
        cell.timeLabel.text = ""
        cell.mytimeLabel.text = ""
        cell.mytextView.text = ""
        cell.textView.text = ""
        cell.message = ""
        cell.message = text
        let senderId = self.chatArray[indexPath.row].senderId
        if senderId == Auth.getUserId() {
            cell.userImageView.isHidden = true
            cell.timeLabel.isHidden = true
            cell.textView.isHidden = true
            cell.nameLabel.isHidden = true
            cell.mytimeLabel.isHidden = false
            cell.mytextView.isHidden = false
            cell.mytimeLabel.text = dateTextFirst
            cell.mytextView.text = text
            cell.message = text
        } else {
            cell.userImageView.isHidden = false
            cell.textView.isHidden = false
            cell.timeLabel.isHidden = false
            cell.nameLabel.isHidden = false
            cell.mytextView.isHidden = true
            cell.mytimeLabel.isHidden = true
            cell.textView.text = chatArray[indexPath.row].text
            let urlString = chatArray[indexPath.row].senderUrl
            let url = URL(string: urlString)
            cell.nameLabel.text = chatArray[indexPath.row].senderName
            cell.userImageView.sd_setImage(with: url, completed: nil)
            cell.timeLabel.text = dateTextFirst
            cell.yourMessaege = text
            
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
