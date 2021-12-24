import UIKit
import CDAlertView

final class TalkViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    var coordinator:TalkCoordinator?
    private lazy var refreshView: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return view
    }()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNav()
    }

    // MARK: - SetupMethod
    private func setupNav() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.nib(), forCellReuseIdentifier: CustomCell.id)
        tableView.addSubview(refreshView)
    }
  
    private func setupBinding() {
    
    }


    @objc private func handleSchedule() {
        print(#function)

    }
    @objc private func handleRefresh() {
       
    }
}
// MARK: - tableViewdatasource
extension TalkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id, for: indexPath) as? CustomCell else { fatalError() }
        return cell
    }
}
// MARK: - UITableViewDelegate
extension TalkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
