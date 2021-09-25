import UIKit
import Firebase
import SDWebImage
import NVActivityIndicatorView
import CDAlertView

class ChatListViewController:UIViewController{
    
    //Mark:Properties
    @IBOutlet weak var tableView: UITableView!
    private let fetchData = FetchFirestoreData()
    private var chatArray = [[Chat]]()
    private var chatModelArray = [ChatRoom]()
    private var userArray = [User]()
    private var anotherUserArray = [User]()
    private var me:User?
    private var you:User?
    private var lastCommentArray = [Chat]()
    private var IndicatorView:NVActivityIndicatorView!
    private let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    private var teams = [TeamModel]()
    private let section = ["グループチャット","ダイレクトメッセージ"]
    private var selectedTeam:TeamModel?
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    private var sortLastCommentArray = [Chat]()
    private var sortUserArray = [User]()
    private var sortAnotherUserArray = [User]()
    private var groupChatArray = [GroupChatModel]()
    private var sortGroupArray = [TeamModel]()
    
    //Mark:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupTableView()
        setupFetchDataDelegate()
        setupOwnTeamData()
        setupNotification()
    }
    
    private func setupFetchDataDelegate () {
        fetchData.chatDelegate = self
        fetchData.chatRoomDelegate = self
    }
    
    //Mark:setupTableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Utility.CellId.CellGroupId)
    }
    
    //Mark:setupNotification
    private func setupNotification() {
//        let boolArray = UserDefaults.standard.array(forKey: Auth.getUserId()) as? [Bool]
//        boolArray?.isEmpty == false {
//            
//        }
        self.notification(uid: Auth.getUserId()) { bool in
            if bool == true {
                
                let alertType = CDAlertViewType.notification
                let alert = CDAlertView(title: "新規参加申請が来ております。", message: "お知らせ画面で確認しよう!", type: alertType)
                let alertAction = CDAlertViewAction(title: "OK", font: UIFont.boldSystemFont(ofSize: 14), textColor: UIColor.blue, backgroundColor: .white)
                
                alert.add(action: alertAction)
                alert.hideAnimations = { (center, transform, alpha) in
                    transform = .identity
                    alpha = 0
                }
                alert.show() { (alert) in
                    print("completed")
                }
                Firestore.changeTrue(uid: Auth.getUserId())
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IndicatorView.startAnimating()
        setupData()
        setupOwnTeamData()
        let image = UIImage(named: Utility.ImageName.double)
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //Mark:
    private func setupIndicator () {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
    
    //Mark: setupData
    private func setupData() {
        Firestore.getChatData(uid: Auth.getUserId()) { chatId in
            self.fetchData.getChatRoomModel(chatId:chatId)
            
            for i in 0..<chatId.count {
                self.fetchData.getChat(chatId: chatId[i])
            }
        }
    }
    //Mark :setupOwnTeam
    private func setupOwnTeamData() {
        Firestore.getOwnTeam(uid: Auth.getUserId()) { teams in
            self.teams = teams
            for i in 0..<teams.count {
                let teamId = teams[i].teamId
                self.fetchData.getGroupChat(teamId: teamId)
            }
        }
    }
}




//Mark:tableViewdelegate,datasource
extension ChatListViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return teams.count
        } else if section == 1 {
            return chatModelArray.count
        }
        return chatModelArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return section.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Utility.CellId.CellGroupId,for: indexPath) as! GroupCell
        
        cell.cellImagevView.layer.cornerRadius = 30
        cell.cellImagevView.layer.masksToBounds = true
        cell.label.font = UIFont.boldSystemFont(ofSize: 14)
        if indexPath.section == 0 {
            cell.commentLabel.isHidden = true
            cell.timeLabel.isHidden = true
            let urlString = teams[indexPath.row].teamImageUrl
            let url = URL(string: urlString)
            cell.cellImagevView.sd_setImage(with: url, completed: nil)
            cell.label.text = teams[indexPath.row].teamName
            cell.cellImagevView.contentMode = .scaleAspectFill
            
            
        } else if indexPath.section == 1 {
            
            let userId = self.chatModelArray[indexPath.row].user
            
            cell.commentLabel.isHidden = false
            cell.timeLabel.isHidden = true
            cell.commentLabel.text = sortLastCommentArray[indexPath.row].text
            
            let date = sortLastCommentArray[indexPath.row].sendTime
            if  date != nil {
                if let safeTimeStamp = date {
                    let safeDate = safeTimeStamp.dateValue()
                    let dateText = self.formatter.string(from: safeDate)
                    cell.timeLabel.text = dateText
                    cell.timeLabel.isHidden = false
                }
            }
            if Auth.getUserId() == userId {
                cell.label.text = sortAnotherUserArray[indexPath.row].name
                let urlString = sortAnotherUserArray[indexPath.row].profileImageUrl
                let url = URL(string: urlString)
                cell.cellImagevView.sd_setImage(with: url, completed: nil)
                cell.cellImagevView.chageCircle()
            } else {
                cell.label.text = sortUserArray[indexPath.row].name
                let urlString = sortUserArray[indexPath.row].profileImageUrl
                let url = URL(string: urlString)
                cell.cellImagevView.sd_setImage(with: url, completed: nil)
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        if indexPath.section == 0 {
            let team = teams[indexPath.row]
            self.selectedTeam = team
            performSegue(withIdentifier: Utility.Segue.groupChat, sender: nil)
        } else if indexPath.section == 1 {
            let userId = self.chatModelArray[indexPath.row].user
            if Auth.getUserId() == userId {
                me = sortUserArray[indexPath.row]
                you = sortAnotherUserArray[indexPath.row]
                performSegue(withIdentifier: Utility.Segue.gotoChatRoom, sender: nil)
            } else {
                me = sortAnotherUserArray[indexPath.row]
                you = sortUserArray[indexPath.row]
                performSegue(withIdentifier: Utility.Segue.gotoChatRoom, sender: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Utility.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let id = chatModelArray[indexPath.row].chatRoom
            let userId = sortUserArray[indexPath.row].uid
            Firestore.deleteData(collectionName: "ChatRoom", documentId: id)
            Ref.ChatroomRef.document(id).collection("Content").getDocuments { snapShot, error in
                if let error = error {
                    print(error)
                    return
                }
                guard let document = snapShot?.documents else { return }
                document.forEach { element in
                    let chatId = element.documentID
                    Ref.ChatroomRef.document(id).collection("Content").document(chatId).delete()
                }
            }
            Firestore.deleteSubCollectionData(collecionName: "User", documentId: Auth.getUserId(), subCollectionName: "ChatRoom", subId: id)
            if userId == Auth.getUserId() {
                let uid = sortAnotherUserArray[indexPath.row].uid
                Firestore.deleteSubCollectionData(collecionName: "User", documentId: uid, subCollectionName: "ChatRoom", subId: id)
            } else {
                Firestore.deleteSubCollectionData(collecionName: "User", documentId: userId, subCollectionName: "ChatRoom", subId: id)
            }
            chatArray.remove(at: indexPath.row)
            sortUserArray.remove(at: indexPath.row)
            sortAnotherUserArray.remove(at: indexPath.row)
            chatModelArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoChatRoom {
            let vc = segue.destination as! ChatViewController
            vc.me = self.me
            vc.you = self.you
        }
        if segue.identifier == Utility.Segue.groupChat {
            let vc = segue.destination as! GroupChatViewController
            vc.team = self.selectedTeam
        }
    }
}

extension ChatListViewController: GetChatDataDelgate {
    
    func getChatData(chatArray: [Chat]) {
        self.chatArray.append(chatArray)
    }
}

extension ChatListViewController: GetChatRoomDataDelegate {
    
    func getChatRoomData(chatRoomArray: [ChatRoom]) {
        print(#function)
        self.anotherUserArray = []
        self.userArray = []
        self.lastCommentArray = []
        self.sortUserArray = []
        self.sortAnotherUserArray = []
        self.sortLastCommentArray = []
        self.chatModelArray = chatRoomArray
        for i in 0..<chatModelArray.count {
            let id1 = chatModelArray[i].user
            let id2 = chatModelArray[i].user2
            let chatId = chatModelArray[i].chatRoom
            Firestore.getUserData(uid: id1) { user1 in
                guard let user = user1 else { return }
                self.userArray.append(user)
            }
            Firestore.getUserData(uid: id2) { user2 in
                guard let user = user2 else { return }
                self.anotherUserArray.append(user)
            }
            Firestore.getChatLastData(chatId: chatId) { lastComment in
                self.lastCommentArray.append(lastComment)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let sortArray = self.lastCommentArray.enumerated().sorted { a, b in
                guard let time = a.element.sendTime?.dateValue() else { return false }
                guard let time2 = b.element.sendTime?.dateValue() else { return false }
                return time > time2
            }
            
            for i in 0..<sortArray.count {
                let index = sortArray[i].offset
                self.sortUserArray.append(self.userArray[index])
                self.sortAnotherUserArray.append(self.anotherUserArray[index])
                self.sortLastCommentArray.append(self.lastCommentArray[index])
            }
            self.IndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
}




