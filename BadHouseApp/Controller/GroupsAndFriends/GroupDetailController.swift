import UIKit
import SDWebImage
import Firebase
import NVActivityIndicatorView
import Charts
import FacebookCore
import SwiftUI

final class GroupDetailController: UIViewController {
    // MARK: - Properties
    private let fetchData = FetchFirestoreData()
    var team: TeamModel?
    var friend: User?
    var teamPlayers = [User]()
    var friends = [User]()
    var me: User?
    @IBOutlet private weak var friendImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var teamNameLabel: UILabel! {
        didSet {
            teamNameLabel.font = .boldSystemFont(ofSize: 20)
        }
    }
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var teamTagStackView: UIStackView! {
        didSet {
            teamTagStackView.distribution = .fillEqually
            teamTagStackView.axis = .horizontal
            teamTagStackView.spacing = 5
        }
    }
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var placeStackView: UIStackView!
    @IBOutlet private weak var timeStackView: UIStackView!
    @IBOutlet private weak var priceStackView: UIStackView!
    @IBOutlet private weak var pieView: PieChartView!
    @IBOutlet private weak var barChartView: BarChartView!
    private let teamMemberCellId = Constants.CellId.MemberCellId
    private var genderArray = [Int]()
    private var indicatorView: NVActivityIndicatorView!
    private var rawData: [Int] = []
    @IBOutlet weak var withdrawButton: UIButton! {
        didSet {
            withdrawButton.updateButton(radius: 15,
                                        backColor: Constants.AppColor.OriginalBlue,
                                        titleColor: .systemGray6,
                                        fontSize: 14)
        }
    }
    var flag = false
    @IBOutlet weak var teamStackView: UIStackView!
    @IBOutlet private weak var updateButton: UIButton! {
        didSet {
            updateButton.updateButton(radius: 15,
                                      backColor:
                                        UIColor(named: Constants.AppColor.darkColor)!,
                                      titleColor: Constants.AppColor.OriginalBlue,
                                      fontSize: 14)
        }
    }
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var inviteButton: UIBarButtonItem! {
        didSet {
            inviteButton.customView?.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupDelegate()
        indicatorView.startAnimating()
        setupData()
        setUpTeamStatus()
        setUpTeamPlayer()
        setupGraph()
        changeUI()
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.AppColor.darkColor)
        navigationController?.navigationBar.tintColor = UIColor(named: Constants.AppColor.darkColor)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavAccessory()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    // MARK: - setupMethod
    private func setupData() {
        guard let teamId = team?.teamId else { return }
        TeamService.getTeamTagData(teamId: teamId) {[weak self] tags in
            guard let self = self else { return }
            if tags.count <= 1 {
                let button = UIButton(type: .system).cretaTagButton(text: "バド好き歓迎")
                let button2 = UIButton(type: .system).cretaTagButton(text: "仲良く")
                button.titleLabel?.font = .boldSystemFont(ofSize: 14)
                button2.titleLabel?.font = .boldSystemFont(ofSize: 14)
                self.teamTagStackView.addArrangedSubview(button)
                self.teamTagStackView.addArrangedSubview(button2)
            }
            for i in 0..<tags.count {
                let title = tags[i].tag
                let button = UIButton(type: .system).cretaTagButton(text: title)
                button.titleLabel?.font = .boldSystemFont(ofSize: 14)
                if i == 4 { return }
                self.teamTagStackView.addArrangedSubview(button)
            }
        }
    }
    private func setUpTeamPlayer() {
        print(#function)
        let group = DispatchGroup()
        guard let teamId = team?.teamId else { return }
        TeamService.getTeamPlayerData(teamId: teamId) { membersId in
            self.teamPlayers = []
            for i in 0..<membersId.count {
                group.enter()
                let teamPlayerId = membersId[i]
                UserService.getUserData(uid: teamPlayerId) { teamPlayer in
                    defer { group.leave() }
                    guard let teamPlayer = teamPlayer else { return }
                    self.teamPlayers.append(teamPlayer)
                }
            }
            group.notify(queue: .main) {
                self.fetchData.fetchGenderCountData(teamPlayers: self.teamPlayers)
                self.fetchData.searchTeamPlayerLevelCount(teamPlayers: self.teamPlayers)
                self.indicatorView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    private func setupDelegate() {
        fetchData.chartsDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func setupIndicator() {
        indicatorView = self.setupIndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor,
                             width: 100,
                             height: 100)
    }
    private func setUpTeamStatus() {
        print(#function)
        let nib = TeammemberCell.nib()
        collectionView.register(nib, forCellWithReuseIdentifier: teamMemberCellId)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        guard let urlString = team?.teamImageUrl else { return }
        guard let url = URL(string: urlString) else { return }
        friendImageView.sd_setImage(with: url, completed: nil)
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.chageCircle()
        friendImageView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        friendImageView.layer.borderWidth = 2
        friendImageView.layer.masksToBounds = true
        teamNameLabel.text = team?.teamName
        timeLabel.text = team?.teamTime
        placeLabel.text = team?.teamPlace
        priceLabel.text = "\(team?.teamLevel ?? "")/月"
    }
    private func setupPieChart() {
        var entry = [ChartDataEntry]()
        for i in 0..<genderArray.count {
            guard let gender = Gender(rawValue: i)?.name else { return }
            entry.append(PieChartDataEntry(value: Double(genderArray[i]),
                                           label: gender,
                                           data: genderArray[i]))
        }
        let pieChartDataSet = PieChartDataSet(entries: entry, label: "男女比")
        pieChartDataSet.entryLabelFont = .boldSystemFont(ofSize: 12)
        pieChartDataSet.drawValuesEnabled = false
        let stringAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.boldSystemFont(ofSize: 16.0)
        ]
        let string = NSAttributedString(string: "男女比",
                                        attributes: stringAttributes)
        pieView.holeColor = UIColor(named: Constants.AppColor.darkColor)
        pieView.centerAttributedText = string
        pieView.legend.textColor = .label
        pieChartDataSet.valueTextColor = .label
        pieView.legend.enabled = false
        pieView.data = PieChartData(dataSet: pieChartDataSet)
        let colors = [.blue, .red, Constants.AppColor.OriginalBlue]
        pieChartDataSet.colors = colors
    }
    private func setupGraph() {
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset + 1),
                                                                   y: Double($0.element)) }
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelCount = rawData.count
        barChartView.leftAxis.labelCount = 10
        barChartView.xAxis.labelTextColor = .darkGray
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.axisMaximum = 10
        barChartView.legend.enabled = false
        dataSet.colors = [.lightGray]
    }
    private func changeUI() {
        withdrawButton.isHidden = flag
        chatButton.isHidden = flag
        updateButton.isHidden = flag
        if flag == true {
            navigationItem.setRightBarButton(nil, animated: true)
        }
        friendImageView.isUserInteractionEnabled = !flag
    }
    // MARK: - IBAction
    @IBAction private func gotoInvite(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.inviteVC) as! PlusTeamPlayerController
        vc.friends = self.friends
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func updateTeamInfo(_ sender: Any) {
        print(#function)
        guard let team = self.team else { return }
        let vc = UpdateTeamController(team: team)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    @IBAction private func gotoGroup(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupChatVC) as! GroupChatController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func go(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.GroupChatVC) as! GroupChatController
        vc.team = self.team
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction private func withdraw(_ sender: Any) {
        print(#function)
        guard let teamId = team?.teamId else { return }
        DeleteService.deleteSubCollectionData(collecionName: "Users",
                                              documentId: AuthService.getUserId(),
                                              subCollectionName: "OwnTeam",
                                              subId: teamId)
        DeleteService.deleteSubCollectionData(collecionName: "Teams",
                                              documentId: teamId,
                                              subCollectionName: "TeamPlayer",
                                              subId: AuthService.getUserId())
        navigationController?.popViewController(animated: true
        )
    }
    // MARK: - prepareMethod
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.gotoInvite {
            let vc = segue.destination as! PlusTeamPlayerController
            vc.friends = self.friends
            vc.team = self.team
        }
    }
}
// MARK: - FetchChartsDataDelegate
extension GroupDetailController: FetchChartsDataDelegate {
    func fetchGenderCount(countArray: [Int]) {
        self.genderArray = countArray
        self.setupPieChart()
    }
    func fetchBarData(countArray: [Int]) {
        self.rawData = countArray
        self.setupGraph()
    }
}
// MARK: - backDelegate
extension GroupDetailController: backDelegate {
    func updateTeamData(vc: UpdateTeamController) {
        vc.dismiss(animated: true, completion: nil)
        guard let id = team?.teamId else { return }
        TeamService.getTeamData(teamId: id) { team in
            self.team = team
            self.placeLabel.text = team.teamPlace
            self.timeLabel.text = team.teamTime
            self.priceLabel.text = team.teamLevel
            let urlString = team.teamImageUrl
            let url = URL(string: urlString)
            self.friendImageView.sd_setImage(with: url)
        }
    }
}
// MARK: - UICollectionViewDataSource
extension GroupDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teamPlayers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: teamMemberCellId, for: indexPath) as! TeammemberCell
        let memberName = teamPlayers[indexPath.row].name
        let urlString = teamPlayers[indexPath.row].profileImageUrl
        cell.configure(name: memberName, url: urlString)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension GroupDetailController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.UserDetailVC) as! UserDetailController
        vc.user = teamPlayers[indexPath.row]
        vc.me = self.me
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension GroupDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
