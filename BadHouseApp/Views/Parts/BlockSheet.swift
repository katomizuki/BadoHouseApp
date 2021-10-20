import Foundation
import UIKit
enum BlockOptions: Int {
    case dismiss
    case block
}
protocol BlockDelegate: AnyObject {
    func blockSheet(option: BlockOptions)
}
class BlockSheet: NSObject {
    // Mark properties
    private var user: User?
    private let tableView = UITableView()
    weak var delegate: BlockDelegate?
    private var window: UIWindow?
    private var tableViewHeight = CGFloat()
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    // Mark Initialize
    init(user: User) {
        self.user = user
        super.init()
        setupTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Mark setupMethod
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 5
        tableView.backgroundColor = .yellow
        tableView.register(BlockCell.self, forCellReuseIdentifier: "cellId")
    }
    // Mark helperMethod
    func show() {
        print(#function)
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow
        }) else { return }
        self.window = window
        window.backgroundColor = .white
        window.addSubview(tableView)
        window.addSubview(blackView)
        let height = CGFloat(2 * 40) + 100
        blackView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: window.frame.width,
                                 height: window.frame.height - height)
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0,
                                 y: window.frame.height,
                                 width: window.frame.width,
                                 height: tableViewHeight)
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 1
            self.showTable(show: true)
        }
    }
    private func showTable(show: Bool) {
        guard let window = window else { return }
        let height  = tableViewHeight
        let y = show ? window.frame.height - height: window.frame.height
        tableView.frame.origin.y = y
    }
    // Mark selector
    @objc private func handleDismiss() {
        print(#function)
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 180
        }
    }
}
// Mark tableViewDelegate
extension BlockSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return mainView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        guard let option = BlockOptions(rawValue: indexPath.row) else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.blackView.alpha = 0
            self.showTable(show: false)
        }) { _ in
            self.delegate?.blockSheet(option: option)
        }
    }
}
// Mark tableViewDatasource
extension BlockSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! BlockCell
        cell.flag = indexPath.row == 1 ? true : false
        return cell
    }
}
