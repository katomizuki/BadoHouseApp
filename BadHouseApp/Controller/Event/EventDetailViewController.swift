

import UIKit
import SDWebImage
import MapKit
import CoreLocation
import Charts
import Firebase

class EventDetailViewController: UIViewController {
   
    //Mark :Properties
    var event:Event?
    var team:TeamModel?
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var timeToLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var gatherCountLabel: UILabel!
    @IBOutlet weak var courtLabel: UILabel!
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var leaderLabel: UILabel!
    @IBOutlet weak var leaderImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var barView: BarChartView!
    private var genderArray = [Int]()
    private var genderValue = ["男性","女性","その他"]
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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lastTimeStackView: UIStackView!
    @IBOutlet weak var gatherStackView: UIStackView!
    @IBOutlet weak var courtStackView: UIStackView!
    @IBOutlet weak var kindStackView: UIStackView!
    @IBOutlet weak var levelStackView: UIStackView!
    @IBOutlet weak var moneyStackView: UIStackView!
    @IBOutlet weak var placeStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Mark:Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        setupCell()
        fetchData.delegate = self
        fetchData.barDelegate = self
        setupTag()
        setupUnderLine()
        setupUser()
        Firestore.getUserData(uid: Auth.getUserId()) { user in
            self.me = user
        }
    }
    
    
    //Mark:SetupMethod
    private func setData() {
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamPlayer(teamId: teamId) { teamPlayers in
            for i in 0..<teamPlayers.count {
                let id = teamPlayers[i]
                Firestore.getUserData(uid: id) { teamPlayer in
                    guard let member = teamPlayer else { return }
                    print(member)
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
        collectionView.register(nib, forCellWithReuseIdentifier: Utility.CellId.MemberCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        joinButton.layer.cornerRadius = 15
        joinButton.layer.masksToBounds = true
    }
    
    private func setupUI() {
        //Mark: updateImage
        guard let urlString = event?.eventUrl else { return }
        let url = URL(string: urlString)
        eventImageView.sd_setImage(with: url, completed: nil)
        eventImageView.contentMode = .scaleAspectFill
        guard let groupUrlString = event?.teamImageUrl else { return }
        let groupUrl = URL(string: groupUrlString)
        groupImageView.sd_setImage(with: groupUrl, completed: nil)
        groupImageView.chageCircle()
        
        //Mark:textLabel
        titleLabel.text = event?.eventTitle
        groupLabel.text = event?.teamName
        var start = event?.eventStartTime ?? ""
        var last = event?.eventFinishTime ?? ""
        start = changeString(string: start)
        last = changeString(string: last)
        timeLabel.text = "\(start)分 ~"
        timeToLabel.text = "\(last)分"
        gatherCountLabel.text = "\(event?.eventGatherCount ?? "") 人"
        courtLabel.text = "\(event?.eventCourtCount ?? "") 面"
        placeLabel.text = event?.eventPlace
        circleLabel.text = event?.kindCircle
        moneyLabel.text = "\(event?.money ?? "") 円"
        levelLabel.text = event?.eventLevel
        let time = event?.eventTime ?? ""
        endTimeLabel.text = "\(changeString(string: time))分"
        
        //Mark:UpdateMap
        mapView.setRegion(defaultRegion, animated: false)
        let pin = MKPointAnnotation()
        let x =  event?.latitude ?? 0.0
        let y = event?.longitude ?? 0.0
        pin.coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
        mapView.addAnnotation(pin)
        
        //Mark:LeaderDataUpdate
        leaderImageView.chageCircle()
        leaderImageView.backgroundColor = .blue
        joinButton.backgroundColor = Utility.AppColor.OriginalBlue
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
    
    //Mark setupPieChart
    private func setPieChart() {
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
        let colors = [UIColor.blue,.red,Utility.AppColor.OriginalBlue]
        pieChartDataSet.colors = colors
    }
    
    private func setBarChart() {
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1), y: Double($0.element) * 10) }
        barView.scaleXEnabled = false
        barView.scaleYEnabled = false
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        barView.data = data
        barView.rightAxis.enabled = false
        barView.xAxis.labelPosition = .bottom
        barView.xAxis.labelCount = rawData.count
        barView.xAxis.labelTextColor = .darkGray
        barView.xAxis.drawGridLinesEnabled = false
        barView.xAxis.drawAxisLineEnabled = false
        barView.leftAxis.axisMinimum = 1
        barView.leftAxis.axisMaximum = 10
        barView.legend.enabled = false
        dataSet.colors = [Utility.AppColor.OriginalBlue]
    }
    
    private func setupTag() {
        guard let eventId = event?.eventId else { return }
        Firestore.getEventTagData(eventId: eventId) { tags in
            if tags.count <= 1 {
                let button = UIButton(type: .system).cretaTagButton(text: "バド好き歓迎")
                let button2 = UIButton(type: .system).cretaTagButton(text: "仲良く")
                self.stackView.addArrangedSubview(button)
                self.stackView.addArrangedSubview(button2)
            }
            for i in 0..<tags.count {
                let tag = tags[i].tag
                let button = UIButton(type: .system).cretaTagButton(text: tag)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                button.titleLabel?.numberOfLines = 0
                if i == 3 { return }
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
        bottomBorder.backgroundColor = Utility.AppColor.OriginalBlue.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    private func getCGrect(view:UIView)->CGRect {
        return CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 1.0)
    }
    
    private func setupUser() {
        guard let userId = event?.userId else { return }
        Firestore.getUserData(uid: userId) { user in
            self.you = user
            guard let urlString = user?.profileImageUrl else { return }
            let url = URL(string: urlString)
            self.leaderImageView.sd_setImage(with: url, completed: nil)
            let name = user?.name
            self.leaderLabel.text = name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoChat" {
            let vc = segue.destination as! ChatViewController
            guard let me = me else { return }
            guard let you = you else { return }
            vc.me = me
            vc.you = you
        }
    }
}

extension EventDetailViewController:GetGenderCount {
    
    func getGenderCount(count: [Int]) {
        self.genderArray = count
        self.setPieChart()
    }
}

extension EventDetailViewController: GetBarChartDelegate {
    
    func getBarData(count: [Int]) {
        self.rawData = count
        self.setBarChart()
    }
}

extension EventDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: Utility.CellId.MemberCellId, for: indexPath) as! TeammemberCell
        let memberName = teamArray[indexPath.row].name
        let urlString = teamArray[indexPath.row].profileImageUrl
        cell.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 15
        cell.configure(name: memberName, urlString: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
}
