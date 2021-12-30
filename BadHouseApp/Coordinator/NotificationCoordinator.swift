
import UIKit

final class NotificationCoordinator: Coordinator,CheckNotificationFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = CheckNotificationController.init(nibName: R.nib.checkNotificationController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toUserDetail() {
//        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: <#UserDetailViewModel#>))
    }
    func toCircleDetail() {
//        coordinator(to: CircleDetailCoordinator(navigationController: navigationController))
    }
    func toChat() {
        coordinator(to: ChatCoordinator(navigationController: navigationController))
    }
}
