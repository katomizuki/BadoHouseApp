import UIKit
import Firebase
import SDWebImage
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
    private var teams = [TeamModel]()
    private let section = ["グループチャット","ダイレクトメッセージ"]
    private var selectedTeam:TeamModel?
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    private var sortLastCommentArray = [Chat]()
    private var sortUserArray = [User]()
    private var sortAnotherUserArray = [User]()
    private var groupChatArray = [GroupChatModel]()
    private var sortGroupArray = [TeamModel]()
    private var sortChatModelArray = [ChatRoom]()
    
    //Mark:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFetchDataDelegate()
        setupOwnTeamData()
        setupNotification()
        setupNav()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupFetchDataDelegate () {
        fetchData.chatDelegate = self
        fetchData.chatRoomDelegate = self
        fetchData.chatListDelegate = self
        fetchData.myTeamDelegate = self
    }
    
    private func setupNav() {
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:Utility.AppColor.OriginalBlue]
        navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleNotification))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(handleSchedule))
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
        self.notification(uid: Auth.getUserId()) { [weak self]bool in
            if bool == true {
                guard let self = self else { return }
                self.setupCDAlert(title: "新規参加申請が来ております", message: "お知らせ画面で確認しよう!", action: "OK", alertType: CDAlertViewType.notification)
                Firestore.changeTrue(uid: Auth.getUserId())
                LocalNotificationManager.setNotification(2, of: .hours, repeats: false, title: "練習に申し込んだ方と連絡はとれましたか？", body: "ぜひ確認しましょう!", userInfo: ["aps" : ["hello" : "world"]])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
        setupOwnTeamData()
        let image = UIImage(named: Utility.ImageName.double)
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Utility.AppColor.OriginalBlue
        UIApplication.shared.applicationIconBadgeNumber = 0
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
        Firestore.getOwnTeam(uid: Auth.getUserId()) { teamIds in
            self.fetchData.getmyTeamData(idArray: teamIds)
        }
    }
    
    
    private func cleanArray() {
        self.anotherUserArray = []
        self.userArray = []
        self.lastCommentArray = []
        self.chatModelArray = []
        self.sortUserArray = []
        self.sortAnotherUserArray = []
        self.sortLastCommentArray = []
        self.sortChatModelArray = []
    }
    @objc private func handleNotification() {
        performSegue(withIdentifier: Utility.Segue.gotoNotification, sender: nil)
    }
    @objc private func handleSchedule() {
        print(#function)
        Firestore.getUserData(uid: Auth.getUserId()) { user in
            guard let me = user else { return }
            let vc = ScheduleViewController(user: me)
            self.present(vc, animated: true, completion: nil)
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
        //Mark GroupChatCell
        if indexPath.section == 0 {
            cell.commentLabel.isHidden = true
            cell.timeLabel.isHidden = true
            cell.team = teams[indexPath.row]
            //Mark DMCell
        } else if indexPath.section == 1 {
            cell.commentLabel.isHidden = false
            cell.timeLabel.isHidden = true
            cell.setTimeLabelandCommentLabel(chat:sortLastCommentArray[indexPath.row])
            if Auth.getUserId() == self.sortChatModelArray[indexPath.row].user {
                cell.user = sortAnotherUserArray[indexPath.row]
            } else {
                cell.user = sortUserArray[indexPath.row]
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        if indexPath.section == 0 {
            let team = teams[indexPath.row]
            self.selectedTeam = team
            let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.GroupChatVC) as! GroupChatViewController
            vc.team = self.selectedTeam
            navigationController?.pushViewController(vc, animated: true)
    
        } else if indexPath.section == 1{
            if Auth.getUserId() == sortChatModelArray[indexPath.row].user {
                me = sortUserArray[indexPath.row]
                you = sortAnotherUserArray[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.ChatVC) as! ChatViewController
                vc.me = me
                vc.you = you
                navigationController?.pushViewController(vc, animated: true)
            } else {
                me = sortAnotherUserArray[indexPath.row]
                you = sortUserArray[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.ChatVC) as! ChatViewController
                vc.me = me
                vc.you = you
                navigationController?.pushViewController(vc, animated: true)
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
}

extension ChatListViewController: GetChatDataDelgate {
    
    func getChatData(chatArray: [Chat]) {
        self.chatArray.append(chatArray)
    }
}

extension ChatListViewController: GetChatRoomDataDelegate {
    
    func getChatRoomData(chatRoomArray: [ChatRoom]) {
        print(#function)
        fetchData.getChatListData(chatModelArray: chatRoomArray)
        self.chatModelArray = chatRoomArray
    }
}

extension ChatListViewController :GetChatListDelegate {
    func getChatList(userArray: [User], anotherArray: [User], lastChatArray: [Chat],chatModelArray:[ChatRoom]) {
        cleanArray()
        self.userArray = userArray
        self.anotherUserArray = anotherArray
        self.lastCommentArray = lastChatArray
        self.chatModelArray = chatModelArray
        let sortArray = self.sortArray()
        makeSortArray(sortArray: sortArray)
        self.tableView.reloadData()
    }
    
    private func sortArray()->[EnumeratedSequence<[Chat]>.Element] {
        let sortArray = self.lastCommentArray.enumerated().sorted { a, b in
            guard let time = a.element.sendTime?.dateValue() else { return false }
            guard let time2 = b.element.sendTime?.dateValue() else { return false }
            return time > time2
        }
        return sortArray
    }
    
    private func makeSortArray(sortArray:[EnumeratedSequence<[Chat]>.Element]) {
        for i in 0..<sortArray.count {
            let index = sortArray[i].offset
            self.sortUserArray.append(self.userArray[index])
            self.sortAnotherUserArray.append(self.anotherUserArray[index])
            self.sortLastCommentArray.append(self.lastCommentArray[index])
            self.sortChatModelArray.append(self.chatModelArray[index])
        }
    }
}

extension ChatListViewController:GetMyTeamDelegate {
    func getMyteam(teamArray: [TeamModel]) {
        self.teams = teamArray
        for i in 0..<teams.count {
            let teamId = teams[i].teamId
            self.fetchData.getGroupChat(teamId: teamId)
        }
    }
}
