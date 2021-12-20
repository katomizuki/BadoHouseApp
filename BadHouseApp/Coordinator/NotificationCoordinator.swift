
import UIKit

class NotificationCoordinator: Coordinator {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = CheckNotificationController()
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}
