import UIKit

final class InviteToCircleController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var friendTableView: UITableView! {
        didSet {
            friendTableView.separatorStyle = .none
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
    }
    // MARK: - setupMethod
    private func setupTableView() {
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.register(InviteCell.nib(), forCellReuseIdentifier: InviteCell.id)
        friendTableView.rowHeight = 50
    }
    private func setupNavigationBar() {
        let rightButton = UIBarButtonItem(title: "サークルへ招待",
                                          style: .done,
                                          target: self,
                                          action:     #selector(didTapRightButton))
        navigationItem.rightBarButtonItem = rightButton
    }
    @objc private func didTapRightButton() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - tableviewDataSource
extension InviteToCircleController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InviteCell.id, for: indexPath) as? InviteCell else { fatalError() }
        return cell
    }
}
// MARK: - tableViewDelegate
extension InviteToCircleController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

