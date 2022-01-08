
import UIKit

final class NotificationCoordinator: Coordinator,CheckNotificationFlow {
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        guard let uid = AuthService.getUid() else { return }
        UserService.getUserById(uid: uid) { user in
            let viewModel = NotificationViewModel(user: user, notificationAPI: NotificationService())
            let controller = CheckNotificationController.init(viewModel: viewModel)
            controller.coordinator = self
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    func toUserDetail(_ myData: User, userId: String) {
        UserService.getUserById(uid: userId) { user in
            self.coordinator(to: UserDetailCoordinator(navigationController: self.navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
        }
    }
    func toApplyedFriend(_ user: User) {
        let controller = ApplyedUserListController.init(viewModel: ApplyedUserListViewModel(applyAPI: ApplyService(), user: user))
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toPreJoin(_ user: User) {
        let controller = PreJoinController.init(viewModel: PreJoinViewModel(joinAPI: JoinService(), user: user))
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    func toPreJoined(_ user: User) {
        let controller = PreJoinedListController.init(viewModel: PreJoinedViewModel(joinAPI: JoinService(), user: user))
        self.navigationController.pushViewController(controller, animated: true)
    }
}
