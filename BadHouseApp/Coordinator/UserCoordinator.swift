import UIKit
import Domain
import Infra

final class UserCoordinator: Coordinator, UserFlow {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller: UserController = UserController.init(viewModel:
                                                UserViewModel(
                                                    store: appStore,
                                                    actionCreator:
                                                        UserActionCreator(userAPI: UserRepositryImpl(),
                                                                          applyAPI: ApplyRepositryImpl(), circleAPI: CircleRepositryImpl())))
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toSearchUser(user: Domain.UserModel?) {
        guard let user = user else { return }
        coordinator(to: SearchUserCoordinator(
            navigationController: navigationController,
            viewModel: SearchUserViewModel(
                user: user,
                store: appStore,
                actionCreator: SearchUserActionCreator(userAPI: UserRepositryImpl(),
                                                       applyAPI: ApplyRepositryImpl()))))
    }
    
    func toDetailUser(myData: Domain.UserModel?, user: Domain.UserModel?) {
        guard let user = user else { return }
        guard let myData = myData else { return }
        coordinator(to: UserDetailCoordinator(
            navigationController: navigationController,
            viewModel: UserDetailViewModel(
                myData: myData,
                user: user,
                store: appStore,
                actionCreator:
                    UserDetailActionCreator(userAPI: UserRepositryImpl(),
                                            applyAPI: ApplyRepositryImpl()))))
    }
    
    func toDetailCircle(myData: Domain.UserModel?, circle: Domain.CircleModel?) {
        guard let circle = circle else { return }
        guard let myData = myData else { return }
        coordinator(to: CircleDetailCoordinator(
            navigationController: navigationController,
            viewModel: CircleDetailViewModel(
                myData: myData,
                circle: circle,
                store: appStore,
                actionCreator: CircleDetailActionCreator(
                    circleAPI: CircleRepositryImpl()))))
    }
    
    func toSearchCircle(user: Domain.UserModel?) {
        guard let user = user else { return }
        coordinator(to: SearchCircleCoordinator(
            navigationController: navigationController,
            viewModel: SearchCircleViewModel(
                user: user,
                store: appStore,
                actionCreator: SearchCircleActionCreator(circleAPI: CircleRepositryImpl()))))
    }
    
    func toMyPage(_ vc: UIViewController) {
        let nav = UINavigationController(rootViewController:
                                            UserPageController.init(
                                                viewModel: UpdateUserInfoViewModel(
                                                    store: appStore,
                                                    actionCreator: UpdateUserInfoActionCreator(
                                                        userAPI: UserRepositryImpl()))))
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    
    func toMakeCircle(user: Domain.UserModel?) {
        guard let user = user else { return }
        MakeCicleCoordinator(navigationController: self.navigationController).start(user: user)
    }
    
    func toSettings(_ vc: UIViewController, user: Domain.UserModel?) {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UserSettingsController.init(user: user))
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    
    func toSchedule(_ vc: UIViewController, user: Domain.UserModel?) {
        guard let user = user else { return }
        coordinator(to: ScheduleCoordinator(
            navigationController: UINavigationController(),
            viewModel: ScheduleViewModel(
                user: user,
                store: appStore,
                actionCreator:
                    ScheduleActionCreator(userAPI: UserRepositryImpl())), vc: vc))
    }
    
    func toApplyUser(user: Domain.UserModel?) {
        guard let user = user else { return }
            navigationController.pushViewController(
                ApplyFriendController.init(
                    viewModel: ApplyFriendsViewModel(
                        user: user,
                        store: appStore,
                        actionCreator: ApplyFriendsActionCreator(
                            applyAPI:
                            ApplyRepositryImpl()))), animated: true)
    }
    
    func toApplyedUser(user: Domain.UserModel?) {
        guard let user = user  else { return }
            navigationController.pushViewController(
                ApplyedUserListController.init(
                    viewModel: ApplyedUserListViewModel(
                        user: user,
                        store: appStore,
                        actionCreator: ApplyedUserListActionCreator(
                            applyAPI: ApplyRepositryImpl()))), animated: true)
    }
    
    func toTodo() {
        coordinator(to: MyTaskCoordinator(navigationController: navigationController))
    }
}
