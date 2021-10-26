import UIKit
import SkeletonView
// MARK: - Protocol
protocol SearchDetailGroupDelegate: AnyObject {
    func seachDetailGroup(vc: SearchDetailGroupController, time: String, money: String, place: String)
    func dismissGroupVC(vc: SearchDetailGroupController)
}
class SearchDetailGroupController: UIViewController {
    // MARK: - Properties
    private let cellTitleArray = ["活動曜日　○曜日", "会費　〇〇円/月", "場所  〇〇県"]
    private lazy var searchButton: UIButton = {
        let button = RegisterButton(text: "検索")
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        button.backgroundColor = Constants.AppColor.OriginalBlue
        return button
    }()
    weak var delegate: SearchDetailGroupDelegate?
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Constants.ImageName.double), for: .normal)
        button.tintColor = Constants.AppColor.OriginalBlue
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "検索条件"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkText
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
       setupUI()
    }
    // MARK: - setupMethod
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(searchLabel)
        view.addSubview(tableView)
        view.addSubview(searchButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 15,
                         paddingLeft: 15,
                         width: 35,
                         height: 35)
        searchLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           centerX: view.centerXAnchor,
                           centerY: backButton.centerYAnchor,
                           height: 35)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 120,
                         paddingRight: 20,
                         paddingLeft: 20,
                         height: 200)
        searchButton.anchor(top: tableView.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 20,
                            paddingRight: 20,
                            paddingLeft: 20,
                            height: 45)
    }
    // MARK: - Selector
    @objc private func didTapSearchButton() {
        print(#function)

//        self.delegate?.seachDetailGroup(vc: self, time: time, money: money, place: place)
    }
    @objc private func back() {
        self.delegate?.dismissGroupVC(vc: self)
    }
}
// MARK: - UITableViewDelegate-Extension
extension SearchDetailGroupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        var judgeListKeyword = String()
        let vc = GroupSearchListController()
        switch indexPath.row {
        case 0: judgeListKeyword = "day"
        case 1: judgeListKeyword = "money"
        case 2: judgeListKeyword = "place"
        default:break
        }
        vc.judgeListKeyword = judgeListKeyword
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - UITableViewDataSource-Extension
extension SearchDetailGroupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: Constants.AppColor.darkColor)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellTitleArray[indexPath.row]
        return cell
    }
}
