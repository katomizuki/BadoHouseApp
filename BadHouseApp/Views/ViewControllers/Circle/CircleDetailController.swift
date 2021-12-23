import UIKit
import SDWebImage
import Firebase
import Charts

final class CircleDetailController: UIViewController {
    // MARK: - Properties
    private let fetchData = FetchFirestoreData()
    var team: TeamModel?
    var friend: User?
    var teamPlayers = [User]()
    var friends = [User]()
    var me: User?
    @IBOutlet private weak var friendImageView: UIImageView!
    @IBOutlet private weak var pieView: PieChartView!
    @IBOutlet private weak var barChartView: BarChartView!
    private var genderArray = [Int]()
    private var rawData: [Int] = []
    @IBOutlet private weak var teamImageView: UIImageView! {
        didSet {
            teamImageView.layer.cornerRadius = 30
            teamImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet private weak var teamMemberTableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTeamStatus()
        setupGraph()
        setupTableView()
    }
    private func setupTableView() {
        teamMemberTableView.delegate = self
        teamMemberTableView.dataSource = self
        teamMemberTableView.register(MemberCell.nib(), forCellReuseIdentifier: MemberCell.id)
    }
    private func setUpTeamStatus() {
        print(#function)
        guard let urlString = team?.teamImageUrl else { return }
        guard let url = URL(string: urlString) else { return }
        friendImageView.sd_setImage(with: url, completed: nil)
        friendImageView.contentMode = .scaleAspectFill
        friendImageView.chageCircle()
        friendImageView.layer.borderColor = Constants.AppColor.OriginalBlue.cgColor
        friendImageView.layer.borderWidth = 2
        friendImageView.layer.masksToBounds = true
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
}
// MARK: - FetchChartsDataDelegate
extension CircleDetailController: FetchChartsDataDelegate {
    func fetchGenderCount(countArray: [Int]) {
        self.genderArray = countArray
        self.setupPieChart()
    }
    func fetchBarData(countArray: [Int]) {
        self.rawData = countArray
        self.setupGraph()
    }
}
extension CircleDetailController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
extension CircleDetailController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberCell.id,for: indexPath) as? MemberCell else { fatalError() }
        return cell
    }
}
