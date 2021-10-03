

import UIKit
import SDWebImage
import Firebase
import NVActivityIndicatorView
import Charts
import FacebookCore


class GroupDetailViewController: UIViewController, GetGenderCount, GetBarChartDelegate {
    
    //Mark: Properties
    private let fetchData = FetchFirestoreData()
    var team:TeamModel?
    var friend:User?
    var teamPlayers = [User]()
    var friends = [User]()
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamTagStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var placeStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var BarChartView: BarChartView!
    private let teamMemberCellId = Utility.CellId.MemberCellId
    private var genderArray = [Int]()
    private var genderValue = Utility.Data.genderArray
    private var IndicatorView:NVActivityIndicatorView!
    private var rawData: [Int] = []
    @IBOutlet weak var withdrawButton: UIButton!
    var flag = false
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var inviteButton: UIBarButtonItem!
    
    
    //Mark:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupUI()
        updateBorder()
        setupDelegate()
        IndicatorView.startAnimating()
        setupData()
        setUpTeamStatus()
        setUpTeamPlayer()
        setGraph()
        withdrawButton.isHidden = flag
        chatButton.isHidden = flag
        if flag == true {
            navigationItem.setRightBarButton(nil, animated: true)
        }
        friendImageView.isUserInteractionEnabled = !flag
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.title = team?.teamName
    }
        
    //Mark: setupData
    private func setupData() {
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamTagData(teamId: teamId) { tags in
            if tags.count <= 1 {
                let button = UIButton(type: .system).cretaTagButton(text: "バド好き歓迎")
                let button2 = UIButton(type: .system).cretaTagButton(text: "仲良く")
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                self.teamTagStackView.addArrangedSubview(button)
                self.teamTagStackView.addArrangedSubview(button2)
            }
            for i in 0..<tags.count {
                let title = tags[i].tag
                let button = UIButton(type: .system).cretaTagButton(text: title)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                if i == 4 { return }
                self.teamTagStackView.addArrangedSubview(button)
            }
        }
    }
    
    //Mark:setupUI
    private func setupUI() {
        teamTagStackView.distribution = .fillEqually
        teamTagStackView.axis = .horizontal
        teamTagStackView.spacing = 5
        teamNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        withdrawButton.updateButton(radius: 15, backColor: Utility.AppColor.OriginalBlue, titleColor: .white, fontSize: 14)
    }
    
    //Mark:setupDelegate
    private func setupDelegate() {
        fetchData.delegate = self
        fetchData.barDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //Mark: NVActivityIndicatorView
    private func setupIndicator() {
        IndicatorView = self.setupIndicatorView()
        view.addSubview(IndicatorView)
        IndicatorView.anchor(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width:100,height: 100)
    }
    
    //Mark: updateBorder
    private func updateBorder() {
        setupBorder(view: placeStackView)
        setupBorder(view: timeStackView)
    }
    
    //Mark: setupBorder
    private func setupBorder(view:UIView) {
        let border = CALayer()
        border.frame = CGRect(x: view.frame.width - 1,
                              y: 15,
                              width: 5.0,
                              height: view.frame.height - 25)
        border.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(border)
    }
    
    
    //Mark:setupMethod()
    private func setUpTeamPlayer() {
        print(#function)
        
        guard let teamId = team?.teamId else { return }
        Firestore.getTeamPlayer(teamId: teamId) { membersId in
            self.teamPlayers = []
            for i in 0..<membersId.count {
                let teamPlayerId = membersId[i]
                Firestore.getUserData(uid: teamPlayerId) { teamPlayer in
                    guard let teamPlayer = teamPlayer else { return }
                    self.teamPlayers.append(teamPlayer)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchData.getGenderCount(teamPlayers: self.teamPlayers)
                self.fetchData.teamPlayerLevelCount(teamPlayers: self.teamPlayers)
                self.IndicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    //Mark:setupMethod(Team)
    private func setUpTeamStatus() {
        print(#function)
        //Mark: CollectionSetup
        let nib = TeammemberCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: teamMemberCellId)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        //Mark:SetImage
        guard let urlString = team?.teamImageUrl else { return }
        let url = URL(string: urlString)
        friendImageView.sd_setImage(with: url, completed: nil)
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.chageCircle()
        friendImageView.layer.borderColor = Utility.AppColor.OriginalBlue.cgColor
        friendImageView.layer.borderWidth = 2
        friendImageView.layer.masksToBounds = true
        
        //Mark setLabel
        teamNameLabel.text = team?.teamName
        timeLabel.text = team?.teamTime
        placeLabel.text = team?.teamPlace
        priceLabel.text = team?.teamLevel
    }
    
    //Mark:Protocol
    func getGenderCount(count: [Int]) {
            self.genderArray = count
            self.setPieChart()
    }
    
    func getBarData(count: [Int]) {
        self.rawData = count
        self.setGraph()
    }
    
        
    
    @IBAction func gotoInvite(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.inviteVC) as! InviteViewController
        vc.friends = self.friends
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //Mark: PieChar
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
    
    //Mark BarChart
    private func setGraph() {
      
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1), y: Double($0.element)) }
        BarChartView.scaleXEnabled = false
        BarChartView.scaleYEnabled = false
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        BarChartView.data = data
        BarChartView.rightAxis.enabled = false
        BarChartView.xAxis.labelPosition = .bottom
        BarChartView.xAxis.labelCount = rawData.count
        BarChartView.leftAxis.labelCount = 10
        BarChartView.xAxis.labelTextColor = .darkGray
        BarChartView.xAxis.drawGridLinesEnabled = false
        BarChartView.xAxis.drawAxisLineEnabled = false
        BarChartView.leftAxis.axisMinimum = 0
        BarChartView.leftAxis.axisMaximum = 10
        BarChartView.legend.enabled = false
        dataSet.colors = [.lightGray]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Utility.Segue.gotoInvite {
            let vc = segue.destination as! InviteViewController
            vc.friends = self.friends
            vc.team = self.team
        }
      
    }
    @IBAction func gotoGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func go(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func withdraw(_ sender: Any) {
        print(#function)
        guard let teamId = team?.teamId else { return }
        //OwnTeamからDelete,teamPlayerからdelete
        Firestore.deleteSubCollectionData(collecionName: "Users", documentId: Auth.getUserId(), subCollectionName: "OwnTeam", subId: teamId)
        Firestore.deleteSubCollectionData(collecionName: "Teams", documentId: teamId, subCollectionName: "TeamPlayer", subId: Auth.getUserId())
        navigationController?.popViewController(animated: true
        )
    }
    
}


//Mark: CollectionViewDelegate,DataSource
extension GroupDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamPlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teamMemberCellId, for: indexPath) as! TeammemberCell
        let memberName = teamPlayers[indexPath.row].name
        let urlString = teamPlayers[indexPath.row].profileImageUrl
        cell.configure(name: memberName, urlString: urlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Utility.Storyboard.UserDetailVC) as! UserDetailViewController
        vc.user = teamPlayers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
