import UIKit
// swiftlint:disable line_length
final class NotificationCoordinator: Coordinator, CheckNotificationFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let uid = AuthRepositryImpl.getUid() else { return }
        UserRepositryImpl.getUserById(uid: uid) { user in
            let controller = CheckNotificationController.init(viewModel: NotificationViewModel(user: user, notificationAPI: NotificationRepositryImpl()))
            controller.coordinator = self
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
    func toUserDetail(_ myData: User, user: User) {
    self.coordinator(to: UserDetailCoordinator(navigationController: self.navigationController, viewModel: UserDetailViewModel(myData: myData,
                                                                  user: user,
                                                                  userAPI: UserRepositryImpl(),
                                                                  applyAPI: ApplyRepositryImpl())))
        
    }
    
    func toApplyedFriend(_ user: User) {
        navigationController.pushViewController(ApplyedUserListController.init(viewModel: ApplyedUserListViewModel(applyAPI: ApplyRepositryImpl(), user: user)), animated: true)
    }
    
    func toPreJoin(_ user: User) {
        self.navigationController.pushViewController(PreJoinController.init(viewModel: PreJoinViewModel(joinAPI: JoinRepositryImpl(), user: user)), animated: true)
    }
    
    func toPreJoined(_ user: User) {
        self.navigationController.pushViewController(PreJoinedListController.init(viewModel: PreJoinedViewModel(joinAPI: JoinRepositryImpl(), user: user)), animated: true)
    }
    
    func toPracticeDetail(_ myData: User, practice: Practice) {
    coordinator(to: PracticeDetailCoordinator(navigationController: navigationController, viewModel: PracticeDetailViewModel(practice: practice, userAPI: UserRepositryImpl(), circleAPI: CircleRepositryImpl(), isModal: true, joinAPI: JoinRepositryImpl())))
    }
}
