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
        guard let user = user else {
            return
        }
        coordinator(to: SearchUserCoordinator(navigationController: navigationController, viewModel: SearchUserViewModel(userAPI: UserService() ,user: user)))
    }
    func toDetailUser(myData: User?, user: User?) {
        guard let user = user else { return }
            guard let myData = myData else {
                return
            }
        coordinator(to: UserDetailCoordinator(navigationController: navigationController, viewModel: UserDetailViewModel(myData: myData, user: user, userAPI: UserService(), applyAPI: ApplyService())))
       
    }
    func toDetailCircle(myData: User?, circle: Circle?) {
        guard let circle = circle else { return }
        guard let myData = myData else { return }
        coordinator(to: CircleDetailCoordinator(navigationController: navigationController, viewModel: CircleDetailViewModel(myData: myData, circle: circle, circleAPI: CircleService())))
    }
    func toSearchCircle(user:User?) {
        guard let user = user else {
            return
        }
        coordinator(to: SearchCircleCoordinator(navigationController: navigationController,viewModel:  SearchCircleViewModel(circleAPI: CircleService(), user: user)))
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
    func toSettings(_ vc: UIViewController, user: User?) {
        guard let user = user else { return }
        let controller = UserSettingsController.init(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    func toSchedule(_ vc: UIViewController, user: User?) {
        guard let user = user else {
            return
        }
        coordinator(to: ScheduleCoordinator(navigationController: UINavigationController(), viewModel: ScheduleViewModel(userAPI: UserService(), practiceAPI: PracticeServie(), user: user), vc: vc))
       
    }
    func toApplyUser(user: User?) {
        if let user = user {
            navigationController.pushViewController( ApplyFriendController.init(viewModel: ApplyFriendsViewModel(user: user, applyAPI: ApplyService())), animated: true)
        }
        
    }
    func toApplyedUser(user: User?) {
        if let user = user {
            navigationController.pushViewController(ApplyedUserListController.init(viewModel: ApplyedUserListViewModel(applyAPI: ApplyService(), user: user)), animated: true)
        }
    }
}
