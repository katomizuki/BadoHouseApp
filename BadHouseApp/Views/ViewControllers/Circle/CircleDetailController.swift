import UIKit
import SDWebImage
import Firebase
import Charts
import RxSwift

protocol CircleDetailFlow {
    func toUserDetail(user: User?,myData: User)
}
final class CircleDetailController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var backGroundImageView: UIImageView!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.changeCorner(num: 30)
            iconImageView.layer.borderWidth = 1
            iconImageView.layer.borderColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet private weak var tableViewSegment: UISegmentedControl!
    @IBOutlet private weak var pieView: PieChartView! {
        didSet {
            pieView.legend.textColor = .lightGray
            pieView.holeColor = .white
            pieView.legend.enabled = false
            let stringAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.boldSystemFont(ofSize: 12.0)
            ]
            let string = NSAttributedString(string: "男女比",
                                            attributes: stringAttributes)
            pieView.centerAttributedText = string
        }
    }
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var barChartView: BarChartView! {
        didSet {
            barChartView.scaleXEnabled = false
            barChartView.scaleYEnabled = false
            barChartView.rightAxis.enabled = false
            barChartView.xAxis.labelPosition = .bottom
            barChartView.leftAxis.labelCount = 10
            barChartView.xAxis.labelTextColor = .darkGray
            barChartView.xAxis.drawGridLinesEnabled = false
            barChartView.xAxis.drawAxisLineEnabled = false
            barChartView.leftAxis.axisMinimum = 0
            barChartView.leftAxis.axisMaximum = 10
            barChartView.legend.enabled = false
        }
    }
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var teamMemberTableView: UITableView!
    var viewModel: CircleDetailViewModel!
    var coordinator: CircleDetailFlow?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBinding()
        navigationItem.backButtonDisplayMode = .minimal
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.willAppear()
    }
    private func setupTableView() {
        teamMemberTableView.register(MemberCell.nib(), forCellReuseIdentifier: MemberCell.id)
    }
    private func setupBinding() {
        backGroundImageView.sd_setImage(with: viewModel.circle.backGroundUrl)
        iconImageView.sd_setImage(with: viewModel.circle.iconUrl)
        nameLabel.text = viewModel.circle.name
        placeLabel.text = viewModel.circle.place
        priceLabel.text = viewModel.circle.price
        dateLabel.text = viewModel.circle.time
        textView.text = viewModel.circle.additionlText
        
        viewModel.outputs.reload.observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.teamMemberTableView.reloadData()
                self?.setupPieChart()
                self?.setupGraph()
            }.disposed(by: disposeBag)
        
        viewModel.outputs.memberRelay.bind(to: teamMemberTableView.rx.items(cellIdentifier: MemberCell.id,
                                                                            cellType: MemberCell.self)) { _,item,cell in
            cell.configure(item)
        }.disposed(by: disposeBag)
        
        teamMemberTableView.rx.itemSelected.bind(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            if self.tableViewSegment.selectedSegmentIndex == 0 {
                self.coordinator?.toUserDetail(user: self.viewModel.allMembers[indexPath.row],
                                               myData: self.viewModel.myData)
            } else {
                self.coordinator?.toUserDetail(user: self.viewModel.friendsMembers[indexPath.row],
                                               myData: self.viewModel.myData)
            }
        }).disposed(by: disposeBag)
    }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        viewModel.inputs.changeMember(sender.selectedSegmentIndex)
    }
    private func setupPieChart() {
        let genderArray = viewModel.genderPercentage
        print(genderArray)
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
        pieChartDataSet.valueTextColor = .darkGray
        pieView.data = PieChartData(dataSet: pieChartDataSet)
        let colors = [.blue, .red, UIColor.systemGreen]
        pieChartDataSet.colors = colors
    }
    private func setupGraph() {
        let rawData = viewModel.levelPercentage
        barChartView.xAxis.labelCount = rawData.count
        let entries = rawData.enumerated().map {
            BarChartDataEntry(x: Double($0.offset + 1),
                              y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        dataSet.colors = [.systemBlue]
    }
}
