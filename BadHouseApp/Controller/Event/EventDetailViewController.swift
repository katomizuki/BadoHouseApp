import UIKit
import SDWebImage
import MapKit
import CoreLocation
import Charts
import Firebase
import CDAlertView
import FacebookCore

class EventDetailViewController: UIViewController {
    //Mark :Properties
    var event:Event?
    var team:TeamModel?
    @IBOutlet private weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var groupImageView: UIImageView! {
        didSet {
            groupImageView.chageCircle()
            groupImageView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var groupLabel: UILabel!
    @IBOutlet private weak var timeToLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var gatherCountLabel: UILabel!
    @IBOutlet private weak var courtLabel: UILabel!
    @IBOutlet private weak var circleLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var leaderLabel: UILabel!
    @IBOutlet private weak var leaderImageView: UIImageView! {
        didSet {
            leaderImageView.chageCircle()
            leaderImageView.backgroundColor = Constants.AppColor.OriginalBlue
        }
    }
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var joinButton: UIButton! {
        didSet {
            joinButton.toCorner(num: 15)
            joinButton.backgroundColor = Constants.AppColor.OriginalBlue
        }
    }
    @IBOutlet private weak var pieView: PieChartView!
    @IBOutlet private weak var barView: BarChartView!
    private var genderArray = [Int]()
    private var genderValue = Constants.Data.genderArray
    private var rawData:[Int] = []
    private var fetchData = FetchFirestoreData()
    private var teamArray = [User]()
    private var defaultRegion: MKCoordinateRegion {
        let x =  event?.latitude ?? 0.0
        let y = event?.longitude ?? 0.0
        let coordinate = CLLocationCoordinate2D(
            latitude: x,
            longitude: y
        )
        let span = MKCoordinateSpan (
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        return MKCoordinateRegion(center: coordinate, span: span)
    }
    private var me :User?
    private var you :User?
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var stackView: UIStackView! {
        didSet {
            stackView.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        }
    }
    @IBOutlet private weak var lastTimeStackView: UIStackView!
    @IBOutlet private weak var gatherStackView: UIStackView!
    @IBOutlet private weak var courtStackView: UIStackView!
    @IBOutlet private weak var kindStackView: UIStackView!
    @IBOutlet private weak var levelStackView: UIStackView!
    @IBOutlet private weak var moneyStackView: UIStackView!
    @IBOutlet private weak var placeStackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    private var chatId:String?
    //Mark:Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        setupCell()
        setupTag()
        setupUnderLine()
        setupUser()
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
    }
    //Mark:SetupMethod
    private func setupNav() {
        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationController?.navigationBar.tintColor = Constants.AppColor.OriginalBlue
        let imageView = UIImageView(image: UIImage(named: Constants.ImageName.logoImage))
        imageView.anchor(width: 44, height: 44)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    private func setData() {
        Firestore.getUserData(uid: Auth.getUserId()) { [weak self] user in
            guard let self = self else { return }
            self.me = user
        }
        fetchData.delegate = self
        fetchData.barDelegate = self
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamPlayer(teamId: teamId) { teamPlayers in
            for i in 0..<teamPlayers.count {
                let id = teamPlayers[i]
                Firestore.getUserData(uid: id) { [weak self] teamPlayer in
                    guard let self = self else { return }
                    guard let member = teamPlayer else { return }
                    self.teamArray.append(member)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchData.getGenderCount(teamPlayers: self.teamArray)
                self.fetchData.teamPlayerLevelCount(teamPlayers: self.teamArray)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupCell() {
        let nib = TeammemberCell.nib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.CellId.MemberCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupUI() {
        guard let urlString = event?.eventUrl else { return }
        let url = URL(string: urlString)
        eventImageView.sd_setImage(with: url, completed: nil)
        guard let groupUrlString = event?.teamImageUrl else { return }
        let groupUrl = URL(string: groupUrlString)
        groupImageView.sd_setImage(with: groupUrl, completed: nil)
        
        //Mark:textLabel
        titleLabel.text = "\(event?.eventTitle ?? "")"
        groupLabel.text = "主催チーム \(event?.teamName ?? "")"
        var start = event?.eventStartTime ?? ""
        var last = event?.eventFinishTime ?? ""
        start = changeString(string: start)
        last = changeString(string: last)
        timeLabel.text = "\(start)分~"
        timeToLabel.text = "\(last)分"
        gatherCountLabel.text = "\(event?.eventGatherCount ?? "") 人"
        courtLabel.text = "\(event?.eventCourtCount ?? "") 面"
        placeLabel.text = event?.eventPlace
        circleLabel.text = event?.kindCircle
        moneyLabel.text = "\(event?.money ?? "") 円"
        levelLabel.text = event?.eventLevel
        let time = event?.eventTime ?? ""
        endTimeLabel.text = "\(changeString(string: time))分"
        mapView.setRegion(defaultRegion, animated: false)
        let pin = MKPointAnnotation()
        let x =  event?.latitude ?? 0.0
        let y = event?.longitude ?? 0.0
        pin.coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
        mapView.addAnnotation(pin)
    }
    //Mark:HelperMethod
    private func changeString(string:String)->String {
        var text = string
        let from = text.index(text.startIndex, offsetBy: 5)
        let to = text.index(text.startIndex, offsetBy: 15)
        text = String(text[from...to])
        let index = text.index(text.startIndex, offsetBy: 5)
        text.insert("日", at: index)
        if text.prefix(1) == "0" {
            let index = text.index(text.startIndex, offsetBy: 0)
            text.remove(at: index)
        }
        text = text.replacingOccurrences(of: "/", with: "月")
        text = text.replacingOccurrences(of: ":", with: "時")
        return text
    }
    
    private func setupPieChart() {
        var entry = [ChartDataEntry]()
        for i in 0..<genderArray.count {
            entry.append(PieChartDataEntry(value: Double(genderArray[i]),label:genderValue[i], data: genderArray[i]))
        }
        let pieChartDataSet = PieChartDataSet(entries: entry,label: "男女比")
        pieChartDataSet.entryLabelFont = UIFont.boldSystemFont(ofSize: 12)
        pieChartDataSet.drawValuesEnabled = false
        pieView.centerText = "男女比"
        pieView.legend.enabled = false
        pieView.data = PieChartData(dataSet:pieChartDataSet)
        let colors = [UIColor.blue,.red,Constants.AppColor.OriginalBlue]
        pieChartDataSet.colors = colors
    }
    
    private func setupBarChart() {
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1), y: Double($0.element)) }
        barView.scaleXEnabled = false
        barView.scaleYEnabled = false
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        barView.data = data
        barView.rightAxis.enabled = false
        barView.xAxis.labelPosition = .bottom
        barView.xAxis.labelCount = rawData.count
        barView.leftAxis.labelCount = 10
        barView.xAxis.labelTextColor = .darkGray
        barView.xAxis.drawGridLinesEnabled = false
        barView.xAxis.drawAxisLineEnabled = false
        barView.leftAxis.axisMinimum = 0
        barView.leftAxis.axisMaximum = 10
        barView.legend.enabled = false
        dataSet.colors = [.lightGray]
    }
    
    private func setupTag() {
        guard let eventId = event?.eventId else { return }
        Firestore.getEventTagData(eventId: eventId) { [weak self] tags in
            guard let self = self else { return }
            if tags.count <= 1 {
                let button = UIButton(type: .system).cretaTagButton(text: "バド好き歓迎")
                let button2 = UIButton(type: .system).cretaTagButton(text: "仲良く")
                self.stackView.addArrangedSubview(button)
                self.stackView.addArrangedSubview(button2)
            }
            for i in 0..<tags.count {
                let tag = tags[i].tag
                let button = UIButton(type: .system).cretaTagButton(text: " \(tag) ")
                button.tagButton()
                if i == 5 { return }
                self.stackView.addArrangedSubview(button)
            }
        }
    }
    
    private func setupUnderLine() {
        setupUnderLayer(view: lastTimeStackView)
        setupUnderLayer(view: gatherStackView)
        setupUnderLayer(view: courtStackView)
        setupUnderLayer(view: kindStackView)
        setupUnderLayer(view: levelStackView)
        setupUnderLayer(view: moneyStackView)
        setupUnderLayer(view: placeStackView)
    }
    
    private func setupUnderLayer(view:UIView) {
        let bottomBorder = CALayer()
        bottomBorder.frame = self.getCGrect(view: view)
        bottomBorder.backgroundColor = Constants.AppColor.OriginalBlue.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    private func setupUser() {
        guard let userId = event?.userId else { return }
        Firestore.getUserData(uid: userId) { [weak self] user in
            guard let self = self else { return }
            self.you = user
            guard let urlString = user?.profileImageUrl else { return }
            if urlString == "" {
                self.leaderImageView.image = UIImage(named: Constants.ImageName.noImages)
            } else {
                let url = URL(string: urlString)
                self.leaderImageView.sd_setImage(with: url, completed: nil)
            }
            let name = user?.name
            self.leaderLabel.text = name
        }
    }
    
    //Mark: prepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.gotoChat {
            let vc = segue.destination as! ChatViewController
            guard let me = me else { return }
            guard let you = you else { return }
            vc.me = me
            vc.you = you
            vc.flag = true
        }
    }
    //Mark IBAction
    @IBAction func join(_ sender: Any) {
        print(#function)
        guard let leaderId = event?.userId else { return }
        fetchData.getChatData(meId: Auth.getUserId(), youId: leaderId) { [weak self] chatId in
            guard let self = self else { return }
            if chatId.isEmpty {
                Firestore.sendChatroom(myId: Auth.getUserId(), youId: leaderId) { id in
                    self.chatId = id
                }
            } else {
                self.chatId = chatId
            }
        }
        guard let eventId = event?.eventId else { return }
        Firestore.searchPreJoin(myId: Auth.getUserId(), eventId: eventId) { bool in
            if bool == false {
                //alerだしてOKだったら申請をだして、チャットで自分のステタースを飛ばすその後、画面繊維させる。
                let alert = UIAlertController(title: "参加申請をしますか？", message: "チャットで主催者に自動で連絡がいきます。", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "キャンセル", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    guard let chatId = self.chatId else { return }
                    guard let name = self.me?.name else { return }
                    guard let meId = self.me?.uid else { return }
                    Firestore.sendChat(chatroomId: chatId, senderId: meId, text: "\(name)さんから参加申請がおこなわれました。ご確認の上ご返信ください。", reciverId: leaderId)
                    Firestore.sendePreJoin(myId: meId, eventId: eventId,leaderId: leaderId)
                    self.performSegue(withIdentifier: Constants.Segue.gotoChat, sender: nil)
                    LocalNotificationManager.setNotification(2, of: .hours, repeats: false, title: "申し込んだ練習から返信がありましたか？", body: "ぜひ確認しましょう!")
                }
                alert.addAction(alertAction)
                alert.addAction(cancleAction)
                self.present(alert,animated: true,completion: nil)
            } else  {
                self.setupCDAlert(title: "既に申請しております", message: "主催者からの承認をお待ち下さい", action: "OK", alertType: CDAlertViewType.notification)
            }
        }
    }
    
    //Mark helperMethod
    private func getCGrect(view:UIView)->CGRect {
        return CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 1.0)
    }
}

//Mark:genderDelegate
extension EventDetailViewController:GetGenderCount {
    
    func getGenderCount(count: [Int]) {
        self.genderArray = count
        self.setupPieChart()
    }
}

//Mark chatrtDelegate
extension EventDetailViewController: GetBarChartDelegate {
    
    func getBarData(count: [Int]) {
        self.rawData = count
        self.setupBarChart()
    }
}
//Mark:collectionViewdelegate
extension EventDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.MemberCellId, for: indexPath) as! TeammemberCell
        let memberName = teamArray[indexPath.row].name
        let urlString = teamArray[indexPath.row].profileImageUrl
        cell.configure(name: memberName, urlString: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.UserDetailVC) as! UserDetailViewController
        vc.user = teamArray[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
