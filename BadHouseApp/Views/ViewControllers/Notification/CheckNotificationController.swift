import UIKit

final class CheckNotificationController: UIViewController {
    @IBOutlet private weak var notificationTableView: UITableView!
    var coordinator: NotificationCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    private func setupTableView() {
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.register(NotificationCell.nib(), forCellReuseIdentifier: NotificationCell.id)
    }

}
extension CheckNotificationController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
extension CheckNotificationController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id,for: indexPath) as?  NotificationCell else { fatalError() }
        return cell
    }
}
