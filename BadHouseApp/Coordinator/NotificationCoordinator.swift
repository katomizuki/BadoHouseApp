
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
//        coordinator(to: ChatCoordinator(navigationController: navigationController))
    }
    func toPreJoin() {
        let controller = PreJoinController.init(nibName: "PreJoinController", bundle: nil)
        guard let uid = AuthService.getUid() else { return }
        UserService.getUserById(uid: uid) { user in
            controller.viewModel = PreJoinViewModel(joinAPI: JoinService(), user: user)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
    func toPreJoined() {
        let controller = PreJoinedListController.init(nibName: "PreJoinedListController", bundle: nil)
        guard let uid = AuthService.getUid() else { return }
        UserService.getUserById(uid: uid) { user in
            controller.viewModel = PreJoinedViewModel(joinAPI: JoinService(), user: user)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
}
