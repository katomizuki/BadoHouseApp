import UIKit
import Firebase
import SDWebImage
import CDAlertView
import NVActivityIndicatorView

class ChatListViewController:UIViewController {
    //Mark:Properties
    @IBOutlet private weak var tableView: UITableView!
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
    private var sortLastCommentArray = [Chat]()
    private var sortUserArray = [User]()
    private var sortAnotherUserArray = [User]()
    private var groupChatArray = [GroupChatModel]()
    private var sortGroupArray = [TeamModel]()
    private var sortChatModelArray = [ChatRoom]()
    private let refreshView:UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    private var IndicatorView:NVActivityIndicatorView!
    //Mark:lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFetchDataDelegate()
        setupOwnTeamData()
        setupNotification()
        setupNav()
        setupIndicator()
        IndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
        setupOwnTeamData()
        let image = UIImage(named: Constants.ImageName.double)
        self.navigationController?.navigationBar.backIndicatorImage = image
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        self.navigationController?.navigationBar.tintColor = Constants.AppColor.OriginalBlue
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    //Mark setupMethod
    private func setupFetchDataDelegate () {
        fetchData.chatDelegate = self
        fetchData.myTeamDelegate = self
    }
    
    private func setupNav() {
        navigationItem.title = "トーク"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:Constants.AppColor.OriginalBlue]
        navigationController?.navigationBar.tintColor = Constants.AppColor.OriginalBlue
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: UIBarButtonItem.Style.done, target: self, action: #selector(handleNotification))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .done, target: self, action: #selector(handleSchedule))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width:100,
                             height: 100)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = GroupCell.nib()
        tableView.register(nib, forCellReuseIdentifier: Constants.CellId.CellGroupId)
        tableView.addSubview(refreshView)
    }
    
    private func setupNotification() {
        JoinService.sendNotificationtoPrejoin(uid: AuthService.getUserId()) { [weak self] bool in
            if bool == true {
                guard let self = self else { return }
                self.setupCDAlert(title: "新規参加申請が来ております", message: "お知らせ画面で確認しよう!", action: "OK", alertType: CDAlertViewType.notification)
                JoinService.changePrejoinTrue(uid: AuthService.getUserId())
                LocalNotificationManager.setNotification(2, of: .hours, repeats: false, title: "練習に申し込んだ方と連絡はとれましたか？", body: "ぜひ確認しましょう!")
            }
        }
    }
    
    private func setupData() {
        ChatRoomService.getChatRoomData(uid: AuthService.getUserId()) { [weak self] chatId in
            guard let self = self else { return }
            self.fetchData.fetchChatRoomModelData(chatId:chatId)
            for i in 0..<chatId.count {
                self.fetchData.fetchDMChatData(chatId: chatId[i])
            }
        }
    }
    
    private func setupOwnTeamData() {
        UserService.getOwnTeam(uid: AuthService.getUserId()) {[weak self] teamIds in
            guard let self = self else { return }
            self.fetchData.fetchMyTeamData(idArray: teamIds)
        }
    }
    //Mark helperMethod
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
    //Mark selector
    @objc private func handleNotification() {
        performSegue(withIdentifier: Constants.Segue.gotoNotification, sender: nil)
    }
    
    @objc private func handleSchedule() {
        print(#function)
        UserService.getUserData(uid: AuthService.getUserId()) { user in
            guard let me = user else { return }
            let vc = ScheduleViewController(user: me)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc private func handleRefresh() {
        setupData()
        setupOwnTeamData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshView.endRefreshing()
        }
    }
}
//Mark:tableViewdelegate,datasource
extension ChatListViewController:UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.CellGroupId,for: indexPath) as! GroupCell
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
            if AuthService.getUserId() == self.sortChatModelArray[indexPath.row].user {
                cell.user = sortAnotherUserArray[indexPath.row]
            } else {
                cell.user = sortUserArray[indexPath.row]
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
}

extension ChatListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        if indexPath.section == 0 {
            let team = teams[indexPath.row]
            self.selectedTeam = team
            let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupChatVC) as! GroupChatViewController
            vc.team = self.selectedTeam
            navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.section == 1 {
            if AuthService.getUserId() == sortChatModelArray[indexPath.row].user {
                me = sortUserArray[indexPath.row]
                you = sortAnotherUserArray[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ChatVC) as! ChatViewController
                vc.me = me
                vc.you = you
                navigationController?.pushViewController(vc, animated: true)
            } else {
                me = sortAnotherUserArray[indexPath.row]
                you = sortUserArray[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.ChatVC) as! ChatViewController
                vc.me = me
                vc.you = you
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Constants.AppColor.OriginalBlue
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
//Mark getchatDelegate
extension ChatListViewController: FetchMyChatDataDelgate {
    
    func fetchMyChatData(chatArray: [Chat]) {
        self.chatArray.append(chatArray)
    }
    func fetchMyChatRoomData(chatRoomArray: [ChatRoom]) {
        print(#function)
        fetchData.fetchMyChatListData(chatModelArray: chatRoomArray)
        self.chatModelArray = chatRoomArray
    }
    
    typealias sortChatArray = [EnumeratedSequence<[Chat]>.Element]
    
    func fetchMyChatListData(userArray: [User], anotherArray: [User], lastChatArray: [Chat],chatModelArray:[ChatRoom]) {
        cleanArray()
        self.userArray = userArray
        self.anotherUserArray = anotherArray
        self.lastCommentArray = lastChatArray
        self.chatModelArray = chatModelArray
        let sortArray = self.sortArray()
        makeSortArray(sortArray: sortArray)
        DispatchQueue.main.async {
            self.IndicatorView.stopAnimating()
            self.tableView.reloadData()
        }
    }
    private func sortArray()->sortChatArray {
        let sortArray = self.lastCommentArray.enumerated().sorted { a, b in
            guard let time = a.element.sendTime?.dateValue() else { return false }
            guard let time2 = b.element.sendTime?.dateValue() else { return false }
            return time > time2
        }
        return sortArray
    }
    
    private func makeSortArray(sortArray:sortChatArray) {
        for i in 0..<sortArray.count {
            let index = sortArray[i].offset
            self.sortUserArray.append(self.userArray[index])
            self.sortAnotherUserArray.append(self.anotherUserArray[index])
            self.sortLastCommentArray.append(self.lastCommentArray[index])
            self.sortChatModelArray.append(self.chatModelArray[index])
        }
    }
}
//Mark GetmyTeamDelegate
extension ChatListViewController:FetchMyTeamDataDelegate {
    func fetchMyTeamData(teamArray: [TeamModel]) {
        self.teams = teamArray
        for i in 0..<teams.count {
            let teamId = teams[i].teamId
            self.fetchData.fetchGroupChatData(teamId: teamId)
        }
    }
}
