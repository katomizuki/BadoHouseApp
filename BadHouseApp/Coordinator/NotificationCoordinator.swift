import UIKit
import Domain
import Infra


final class NotificationCoordinator: Coordinator, CheckNotificationFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let uid = AuthRepositryImpl.getUid() else { return }
        UserRepositryImpl.getUserById(uid: uid) { user in
            let controller = CheckNotificationController.init(
                viewModel: NotificationViewModel(user: user,
                                                 store: appStore,
                                                 actionCreator: NotificationActionCreator(
                                                    notificationAPI: NotificationRepositryImpl())), coordinator: self)
            self.navigationController.pushViewController(controller, animated: true)
        }
    }
    
    func toUserDetail(_ myData: Domain.UserModel,
                      user: Domain.UserModel) {
    self.coordinator(to: UserDetailCoordinator(
        navigationController: self.navigationController,
        viewModel: UserDetailViewModel(
            myData: myData,
            user: user,
            store: appStore,
            actionCreator:
                UserDetailActionCreator(userAPI: UserRepositryImpl(),
                                        applyAPI: ApplyRepositryImpl()))))
    }
    
    func toApplyedFriend(_ user: Domain.UserModel) {
        navigationController.pushViewController(
            ApplyedUserListController.init(
                viewModel:
                    ApplyedUserListViewModel(
                        user: user,
                        store: appStore,
                        actionCreator: ApplyedUserListActionCreator(
                            applyAPI: ApplyRepositryImpl()))), animated: true)
    }
    
    func toPreJoin(_ user: Domain.UserModel) {
        self.navigationController.pushViewController(
            PreJoinController.init(viewModel:
                                    PreJoinViewModel(user: user,
                                                     store: appStore,
                                                     actionCreator: PrejoinActionCreator(joinAPI: JoinRepositryImpl()))), animated: true)
    }
    
    func toPreJoined(_ user: Domain.UserModel) {
        self.navigationController.pushViewController(
            PreJoinedListController.init(
                viewModel: PreJoinedViewModel(user: user,
                                              store: appStore,
                                              actionCreator:
                                                PreJoinedActionCreator(
                                                    joinAPI: JoinRepositryImpl()))), animated: true)
    }
    
    func toPracticeDetail(_ myData: Domain.UserModel,
                          practice: Domain.Practice) {
    coordinator(to: PracticeDetailCoordinator(
        navigationController: navigationController,
        viewModel: PracticeDetailViewModel(practice: practice,
                                           isModal: true,
                                           store: appStore,
                                           actionCreator:
                                            PracticeActionCreator(userAPI: UserRepositryImpl(),
                                                                  circleAPI: CircleRepositryImpl(),
                                                                  joinAPI: JoinRepositryImpl()), myData: myData)))
    }
}
