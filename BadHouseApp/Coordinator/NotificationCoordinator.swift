
import UIKit

final class NotificationCoordinator: Coordinator,CheckNotificationFlow {
    
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        guard let uid = AuthService.getUid() else { return }
        UserService.getUserById(uid: uid) { user in
            let controller = CheckNotificationController.init(viewModel: NotificationViewModel(user: user, notificationAPI: NotificationService()))
            controller.coordinator = self
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    func toUserDetail(_ myData: User, user: User) {
        self.coordinator(to: UserDetailCoordinator(navigationController: self.navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
        
    }
    func toApplyedFriend(_ user: User) {
        navigationController.pushViewController(ApplyedUserListController.init(viewModel: ApplyedUserListViewModel(applyAPI: ApplyService(), user: user)), animated: true)
    }
    
    func toPreJoin(_ user: User) {
        self.navigationController.pushViewController(PreJoinController.init(viewModel: PreJoinViewModel(joinAPI: JoinService(), user: user)), animated: true)
    }
    
    func toPreJoined(_ user: User) {
        self.navigationController.pushViewController(PreJoinedListController.init(viewModel: PreJoinedViewModel(joinAPI: JoinService(), user: user)), animated: true)
    }
    func toPracticeDetail(_ myData: User, practice: Practice) {
        coordinator(to: PracticeDetailCoordinator(navigationController: navigationController, viewModel: PracticeDetailViewModel(practice: practice, userAPI: UserService(), circleAPI: CircleService(), isModal: true)))
    }
}
