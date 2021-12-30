import UIKit

class UserCoordinator: Coordinator, UserFlow {
    let navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let controller = UserController.init(nibName: R.nib.userController.name, bundle: nil)
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    func toSearchUser(user:User?) {
        if let user = user {
            let controller = SearchUserController.init(user: user)
            navigationController.pushViewController(controller, animated: true)
        }
    }
    func toDetailUser(myData: User?, user: User?) {
        guard let user = user else { return }
            guard let myData = myData else {
                return
            }
            let viewModel = UserDetailViewModel(myData: myData, user: user, userAPI: UserService())
            coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: viewModel))
       
    }
    func toDetailCircle(myData: User?, circle: Circle?) {
        guard let circle = circle else { return }
        guard let myData = myData else { return }
        let viewModel = CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController,viewModel: viewModel))
    }
    func toSearchCircle(user:User?) {
        guard let user = user else {
            return
        }
        let viewModel = SearchCircleViewModel(circleAPI: CircleService(), user: user)
        coordinator(to: SearchCircleCoordinator(navigationController: navigationController,viewModel: viewModel))
    }
    func toMyPage(_ vc: UIViewController) {
        let controller = UserPageController.init(nibName: R.nib.userPageController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    func toMakeCircle(user: User?) {
        let coordinator =  MakeCicleCoordinator(navigationController: self.navigationController)
        if let user = user {
            coordinator.start(user: user)
        }
    }
    func toSettings(_ vc: UIViewController) {
        let controller = UserSettingsController.init(nibName: R.nib.userSettingsController.name, bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    func toSchedule(_ vc: UIViewController) {
        let controller = ScheduleController.init(nibName: "ScheduleController", bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true, completion: nil)
    }
    func toApplyUser(user: User?) {
        let controller = ApplyFriendController.init(nibName: "ApplyFriendController", bundle: nil)
        if let user = user {
            controller.viewModel = ApplyFriendsViewModel(user: user, applyAPI: ApplyService())
        }
        navigationController.pushViewController(controller, animated: true)
    }
    func toApplyedUser(user: User?) {
        let controller = ApplyedUserListController.init(nibName: "ApplyedUserListController", bundle: nil)
        if let user = user {
            controller.viewModel = ApplyedUserListViewModel(applyAPI: ApplyService(), user: user)
        }
        navigationController.pushViewController(controller, animated: true)
    }
}
